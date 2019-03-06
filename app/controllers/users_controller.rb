# UsersController
class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'app'

  def index
    @page = params[:page] || 1
    @user_type = params[:user_type] || 'active'
    @sort_by = params[:sort_by] || 'first_name'
    @sort_order = params[:sort_order] || 'asc'
    @users = filtered_users(@user_type, @sort_by, @sort_order).order(created_at: 'desc').page(@page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.user_create(user_params)
    @user_type = params[:user_type]
  end

  def edit
    @user = User.where(id: params[:id]).first
    @user_type = params[:user_type]
  end

  def update
    @user = User.where(id: params[:user][:id]).first
    @user_type = params[:user_type]
    @user.skip_password_validation =
      if params[:user][:password].present?
        true
      else
        false
      end
    @user.user_update(user_params)
  end

  def destroy
    @user = User.where(id: params[:id]).first
    @user_type = params[:user_type]
    @user_deleted = @user.update_attributes(deleted_at: Time.now.utc)
  end

  def undelete
    @user_type = params[:user_type]
    @user = User.where(id: params[:user_id]).first
    @user.update_attributes(deleted_at: nil)
  end

  def user_profile
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

  def filtered_users(user_type, sort_by, sort_order)
    users = case user_type
            when 'inactive'
              User.inactive_users
            when 'deleted'
              User.deleted_users
            else
              User.active
            end
    users = users.where('first_name ILIKE :query', query: "%#{params[:first_name]}%")
    users = users.where('last_name ILIKE :query', query: "%#{params[:last_name]}%")
    users = users.where('email ILIKE :query', query: "%#{params[:email]}%")
    users = users.order(sort_by + ' ' + sort_order)
    users
  end
end
