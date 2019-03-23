class Api::Profile::Show < ApiAction
  include Auth::GetCurrentUser

  get "/api/profiles/:username" do
    if user = UserQuery.new.username(username).first?
      json ProfileSerializer.new(user: user, current_user: current_user?)
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end
end
