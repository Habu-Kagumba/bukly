class AuthenticationService
  def initialize(email, password)
    @email = email
    @password = password
  end

  def login
    if user
      user.update_attribute(:logged_in, true)
      JsonWebToken.encode(user_id: user.id)
    end
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by(email: email)
    return user if user && user.authenticate(password)

    raise ExceptionHandlers::AccessDeniedError,
          ExceptionMessages::Messages.access_denied
  end
end
