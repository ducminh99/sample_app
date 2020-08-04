class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user_mailer.activated_account_title")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("user_mailer.reset_password_title")
  end
end
