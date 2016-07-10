class ApiAuthorizeService
  def initialize(headers = {})
    @headers = headers
  end

  def authorize
    { user: user, token: http_auth_header }
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  rescue JWT::ExpiredSignature
    raise ExceptionHandlers::ExpiredSignatureError,
          ExceptionMessages::Messages.expired_sig
  rescue JWT::VerificationError, JWT::DecodeError
    raise ExceptionHandlers::NotAuthenticatedError,
          ExceptionMessages::Messages.access_denied
  end

  def http_auth_header
    auth_headers = headers.fetch("Authorization")
    return auth_headers.split(" ").last
  rescue KeyError
    raise ExceptionHandlers::AccessDeniedError,
          ExceptionMessages::Messages.missing_token
  end
end
