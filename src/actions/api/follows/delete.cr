class Api::Follows::Delete < ApiAction
  include Auth::RequireSignIn

  delete "/api/profile/:username/follow" do
    if user = UserQuery.new.username(username).first?
      follow = FollowQuery.new.follower_id(current_user.id).followed_id(user.id).first?
      follow.try(&.delete)
      json ProfileSerializer.new(user: user, current_user: current_user?)
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end
end
