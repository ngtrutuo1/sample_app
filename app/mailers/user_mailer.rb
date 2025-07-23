class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".account_activation_mail")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".password_reset_mail")
  end

  def resend_confirmation_after_reset user
    @user = user
    mail to: user.email, subject: t(".confirm_password_reset_mail")
  end
end
