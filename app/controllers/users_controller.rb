class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
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

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
