class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      if params[:session][:remember_me] == Settings.checkbox.checked_value
        remember user
      else
        forget user
      end
      redirect_to user

    else
      flash[:danger] = t "sessions.new.error_message"
      redirect_to login_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
