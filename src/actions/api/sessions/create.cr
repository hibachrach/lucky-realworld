class Api::Sessions::Create < ApiAction
  include FindAuthenticatable

  nested_param email : String?, nested_under: user
  nested_param password : String?, nested_under: user

  post "/api/users/login" do
    user = SignInForm.new(Avram::Params.new(email: email, password: password)).submit!

    json UserSerializer.new(user)
  end
end
