class PasswordResetJob < ApplicationJob
  queue_as :default
  def perform(user)
    PasswordMailer.send_reset_email(user).deliver_now
  end
end
