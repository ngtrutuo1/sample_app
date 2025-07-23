class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".account_activation_mail")
  end

  def password_reset
    @greeting = t(".hello")

    mail to: "to@example.org"
  end
end
