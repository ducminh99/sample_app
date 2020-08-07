class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if !user.activated? && user&.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "users.activation.activated_account"
      redirect_to user
    else
      flash[:danger] = t "users.activation.invalid_activated_link"
      redirect_to root_url
    end
  end
end
