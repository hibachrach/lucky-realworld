class Users::Create < ApiAction
  route do
    user = params.nested("user")

    json({
      user: {
        email: user["email"],
        username: user["username"],
        bio: "",
        image: "",
        token: "Doesn't matter yet"
      }
    })
  end
end
