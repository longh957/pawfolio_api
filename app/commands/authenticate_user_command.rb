class AuthenticateUserCommand < BaseCommand
  private

  attr_reader :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def user
    @user ||= User.find_by(email: email)
  end

  def password_valid?
    user && user.authenticate(password)
  end

  def payload
    if password_valid?
      @result = JwtService.encode(contents)
    else
      errors.add(:base, 'Invalid Credentials')
    end
  end

  def contents
    {
      user_id: user.id,
      name: user.name,
      exp: 30.days.from_now.to_i
    }
  end
end
