class AuthenticationService
  def initialize(email, password)
    @email = email
    @password = password
  end

  def create_user
    User.create!(email: email, password: password)
    login
  rescue ActiveRecord::RecordInvalid
    raise
  end

  def login
    JsonWebToken.encode(user_id: user.id) if user
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
