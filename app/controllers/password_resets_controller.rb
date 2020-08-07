class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.sent_email_notification"
      redirect_to root_url
    else
      flash[:danger] = t "password_resets.email_not_found"
      redirect_to new_password_reset_path
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".empty_warning")
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      log_in @user
      flash[:success] = t ".success_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::PASSWORD_RESET_PARAMS
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset.check_expiration"
    redirect_to new_password_reset_url
  end
end
