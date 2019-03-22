class Api::User::Update < ApiAction
  include Auth::RequireSignIn

  put "/api/user" do
    user = UserUpdateForm.update!(current_user, params.nested("user"))
    json UserSerializer.new(user)
  end
end
