module JwtService
  extend self

  def token(user : User)
    payload = {
      "id" => user.id,
      "exp" => 1.hour.from_now.to_unix
    }
    JWT.encode(
      payload,
      Lucky::Server.settings.secret_key_base,
      "HS256"
    )
  end
end
