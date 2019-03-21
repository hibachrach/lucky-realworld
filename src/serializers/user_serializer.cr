class UserSerializer < Lucky::Serializer
  private getter user

  def initialize(@user : User)
  end

  def render
    {
      user: {
        email: user.email,
        username: user.username,
        bio: user.bio,
        image: user.image,
        token: JwtService.token(user)
      }
    }
  end
end
