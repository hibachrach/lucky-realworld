class Api::Users::Create < ApiAction
  route do
    user = SignUpForm.create!(params.nested("user"))
    json UserSerializer.new(user), status: Lucky::Action::Status::Created
  end
end
