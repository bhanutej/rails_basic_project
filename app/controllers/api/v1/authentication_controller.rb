# AuthenticationController
class Api::V1::AuthenticationController < API::ApplicationController
  before_action :validate_contact, only: %i[request_otp verify_otp resend_otp]
  # before_action :validate_country_code, only: %i[request_otp verify_otp resend_otp]
  before_action :validate_username, only: %i[request_otp]
  before_action :registered_user, only: %i[request_otp]
  before_action :validate_otp, only: %i[verify_otp]
  before_action :authenticate_with_phone_number, only: %i[verify_otp resend_otp]
  include AbstractController::Translation
  include Api::Modules::Users

  def request_otp
    if @user.errors.present?
      render_errors(@user.errors.full_messages, t('status.unprocessable_entity'))
    else
      create_user_otp(@user)
    end
  end

  def verify_otp
    user_otp =
      @user.user_otps.where(otp_value: params[:otp], is_validated: false).first
    serve_auth_token(user_otp)
  end

  def resend_otp
    user_otp = @user.user_otps.where(is_validated: false).first
    if user_otp.present?
      user_otp.expiry_date = Time.now.utc + 7200
      user_otp.save
      # send_otp_code(@user.phone_number, user_otp.otp_value)
      logger.debug ">>>OTP>>>#{user_otp.otp_value}"
      render json: { message: 'OTP sent successfully!', otp: user_otp.otp_value }, status: t('status.ok')
    else
      create_user_otp(@user)
    end
  end

  private

  def render_errors(errors, status)
    render json: { errors: errors }, status: status
  end

  def payload(user)
    return nil unless user && user.id

    {
      auth_token: JsonWebToken.encode(user_id: user.id),
      user: { id: user.id, mobile: user.mobile_number, username: user.first_name }
    }
  end

  def validate_contact
    # rubocop:disable LineLength
    render_errors([t('model.validation.message.valid_filed', field: 'mobile number')], t('status.unprocessable_entity')) if params[:mobile_no].blank?
    # rubocop:enable LineLength
  end

  def validate_country_code
    # rubocop:disable LineLength
    render_errors([t('model.validation.message.valid_filed', field: 'country code')], t('status.unprocessable_entity')) if params[:country_code].blank?
    # rubocop:enable LineLength
  end

  def validate_username
    # rubocop:disable LineLength
    render_errors([t('model.validation.message.valid_filed', field: 'username')], t('status.unprocessable_entity')) if params[:username].blank?
    # rubocop:enable LineLength
  end

  def validate_otp
    # rubocop:disable LineLength
    render_errors([t('model.validation.message.valid_filed', field: 'username')], t('status.unprocessable_entity')) if params[:otp].blank?
    # rubocop:enable LineLength
  end

  def registered_user
    @user ||= User.where(contact_number: params[:mobile_no], role: :admin).first
    if @user.present?
      @user.update_attributes(mobile_number: params[:mobile_no])
    else
      @user ||= User.where(mobile_number: params[:mobile_no], role: :user).first
      @user = create_new_user unless @user.present?
    end
    @user.first_name = params[:username]
    @user.skip_password_validation = true
    @user.save
  end

  def user_params
    params.permit(:country_code, :username)
  end

  def create_new_user
    # rubocop:disable LineLength
    @create_new_user ||= User.where(mobile_number: params[:mobile_no]).first_or_initialize
    # rubocop:enable LineLength
  end

  def authenticate_with_phone_number
    # rubocop:disable LineLength
    @user ||= User.find_for_database_authentication(mobile_number: params[:mobile_no])
    render_errors([t('api.authentication.errors.invalid_credentials')], t('status.unauthorized')) unless @user.present?
    # rubocop:enable LineLength
  end

  def serve_auth_token(user_otp)
    if user_otp.present?
      send_auth_token(user_otp)
    else
      render_invalid_otp
    end
  end

  def send_auth_token(user_otp)
    user_otp = update_user_otp(user_otp)
    if user_otp.expiry_date >= Time.now.utc
      render json: payload(@user)
    else
      render_otp_expired
    end
  end

  def update_user_otp(user_otp)
    user_otp.is_validated = true
    user_otp.save
    user_otp
  end

  def render_invalid_otp
    # rubocop:disable LineLength
    render_errors([t('api.authentication.errors.invalid_otp')], t('status.unprocessable_entity'))
    # rubocop:enable LineLength
  end

  def render_otp_expired
    # rubocop:disable LineLength
    render_errors([t('api.authentication.errors.otp_expired')], t('status.unprocessable_entity'))
    # rubocop:enable LineLength
  end
end
