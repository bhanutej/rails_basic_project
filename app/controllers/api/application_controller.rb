# ApplicationController
class API::ApplicationController < ActionController::API
  include AbstractController::Translation
  include ActiveModel::Serializers
  # include Pundit

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from Pundit::NotDefinedError, with: :user_not_authorized

  protected

  def authenticate_request!
    unless user_id_in_token?
      # rubocop:disable LineLength
      render json: { errors: [t('api.authentication.errors.not_authenticated')] }, status: t('status.unauthorized')
      return
    end
    @app_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: [t('api.authentication.errors.not_authenticated')] }, status: t('status.unauthorized')
    # rubocop:enable LineLength
  end

  def user_not_authorized
    # rubocop:disable LineLength
    render json: { errors: [t('api.authentication.errors.unauthorized')] }, status: t('status.unauthorized')
    # rubocop:enable LineLength
  end

  def pundit_user
    @app_user
  end

  private

  def http_token
    @http_token ||=
      if request.headers[t('api.authentication.authorization')].present?
        if request.headers[t('api.authentication.authorization')].split(' ').count == 2
          request.headers[t('api.authentication.authorization')].split(' ').last
        end
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end
