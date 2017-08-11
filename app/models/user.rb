class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base65(48))
  end
end
