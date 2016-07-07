module Requests
  def json
    JSON.parse(response.body)
  end

  def token(user)
    JsonWebToken.encode(user_id: user.id)
  end
end
