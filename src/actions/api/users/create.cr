class Api::Users::Create < ApiAction
  route do
    user = SignUpForm.create!(params.nested("user"))
    json user_serializer(user), status: Lucky::Action::Status::Created
  end

  def user_serializer(user : User)
    {
      user: {
        email: user.email,
        username: user.username,
        bio: nil,
        image: nil,
        token: token(user)
      }
    }
  end

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
