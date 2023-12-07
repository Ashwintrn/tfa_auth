class Jwt
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s[0..10]

  def self.encode(payload, exp = 45.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end