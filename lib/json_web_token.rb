class JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  EXPIRY = 1.month.from_now.to_i
  LEEWAY = 60

  def self.encode(payload, exp = EXPIRY)
    payload[:exp] = exp
    JWT.encode(payload, HMAC_SECRET, "HS256")
  end

  def self.decode(token)
    body = JWT.decode(
      token,
      HMAC_SECRET,
      true,
      leeway: LEEWAY, algorithm: "HS256"
    )

    HashWithIndifferentAccess.new(body[0])
  end
end
