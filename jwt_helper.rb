# jwt_helper.rb

require 'jwt'

module JWTHelper
  SECRET_KEY = 'secret'

  def self.endcode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    decoded_token.first
  rescue JWT::DecodeError => e
    nil
  end

  def self.valid_token?(token)
    decode(token) != nil
  end
end
