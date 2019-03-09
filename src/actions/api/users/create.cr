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
        bio: "",
        image: "",
        token: "Doesn't matter yet"
      }
    }
  end
end
