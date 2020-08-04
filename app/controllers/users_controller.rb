class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :index, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page params[:page]
  end

  def show
    @user = find_user_by_id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "users.new.title"
      redirect_to @user
    else
      flash[:danger] = t "users.new.sign_up_failed"
      redirect_to signup_path
    end
  end

  def edit
    @user = find_user_by_id
  end

  def update
    @user = find_user_by_id
    if @user.update user_params
      flash[:success] = t "users.edit.update_success"
      redirect_to @user
    else
      flash[:danger] = t "users.edit.update_failed"
      redirect_to edit_user_path
    end
  end

  def destroy
    find_user_by_id.destroy
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
    @user = find_user_by_id
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user_by_id user_id = params[:id]
    user = User.find_by id: user_id
    return user if user.present?

    flash[:danger] = t "users.user_not_found"
    redirect_to root_url
  end
end
