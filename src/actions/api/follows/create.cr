class Api::Follows::Create < ApiAction
  include Auth::RequireSignIn

  post "/api/profile/:username/follow" do
    if user = UserQuery.new.username(username).first?
      FollowForm.create!(follower_id: current_user.id, followed_id: user.id)
      json ProfileSerializer.new(user: user, current_user: current_user?)
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end
end
