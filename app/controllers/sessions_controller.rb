class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if authenticated_password? user
      log_in user
      if params[:session][:remember_me] == Settings.checkbox.checked_value
        remember user
      else
        forget user
      end
      redirect_back_or user

    else
      flash[:danger] = t "sessions.new.error_message"
      redirect_to login_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def authenticated_password? user
    user&.authenticate params[:session][:password]
  end
end
