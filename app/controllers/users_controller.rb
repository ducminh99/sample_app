class UsersController < ApplicationController
  before_action :find_user_by_id, except: [:new, :index, :create]
  before_action :logged_in_user, except: [:new, :index, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.is_activated.page params[:page]
  end

  def show
    return if @user.activated?
    redirect_to root_path
    flash[:warning] = t "users.activation.not_activated_account_warning"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.new.check_mail"
      redirect_to root_url
    else
      flash[:danger] = t "users.new.sign_up_failed"
      redirect_to signup_path
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.update_success"
      redirect_to @user
    else
      flash[:danger] = t "users.edit.update_failed"
      redirect_to edit_user_path
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "users.destroy.deleted_user"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.required_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "users.user_not_found"
    redirect_to root_url
  end
end
