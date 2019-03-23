class ProfileSerializer < Lucky::Serializer
  private getter user

  def initialize(@user : User, @current_user : User?)
  end

  def render
    {
      user: {
        username: user.username,
        bio: user.bio,
        image: user.image,
        following: following?
      }
    }
  end

  private def current_user? : User?
    @current_user
  end

  private def following? : Bool
    if current_user = current_user?
      FollowQuery.new.follower_id(current_user.id).followed_id(user.id).any?
    else
      false
    end
  end
end
