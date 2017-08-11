class PasswordMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid
  default from: 'noreply@pawfol.io'

  def send_reset_email(user)
    @user = user
    subject = 'Reset Password Instructions'
    mail(to: @user.email, subject: subject)
  end
end
