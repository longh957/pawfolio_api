class User < ApplicationRecord
  has_secure_password
  has_many :pets
  validates :email, presence: true, uniqueness: true

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48))
    send_password_reset_email
  end

  private

  def send_password_reset_email
    PasswordResetJob.set(wait: 5.seconds).perform_later(self)
  end
end
