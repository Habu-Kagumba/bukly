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

  def logout(curr_user, token)
    curr_user.invalid_tokens.create!(token: token)
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
