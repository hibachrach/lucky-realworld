class Api::User::Show < ApiAction
  include Auth::RequireSignIn

  get "/api/user" do
    json UserSerializer.new(current_user)
  end
end
