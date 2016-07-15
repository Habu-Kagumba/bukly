module Requests
  def json
    JSON.parse(response.body)
  end

  def token(user)
    JsonWebToken.encode(user_id: user.id)
  end

  def headers
    {
      accept: "application/vnd.bukly+json; version=1"
    }
  end

  def auth_headers
    headers.merge(authorization: token(user))
  end
end
