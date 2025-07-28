class ApplicationMailer < ActionMailer::Base
  default from: Settings.development.default_email
  layout "mailer"
end
