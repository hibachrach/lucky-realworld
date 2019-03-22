module Auth::RequireSignIn
  macro included
    before require_sign_in
  end

  class UnauthorizedError < ::Exception
  end

  private def require_sign_in
    if current_user?
      continue
    else
      raise UnauthorizedError.new
    end
  end

  # Tells the compiler that the current_user is not nil since we have checked
  # that the user is signed in
  private def current_user : User
    current_user?.not_nil!
  end

  private def current_user? : User?
    if jwt = jwt_from_header
      payload, _header = JWT.decode(jwt, Lucky::Server.settings.secret_key_base, "HS256")
      if id = payload["id"]?.try(&.as_i)
        User::BaseQuery.new.id(id).first?
      end
    end
  rescue JWT::DecodeError
    nil
  end

  private def jwt_from_header : String?
    auth_header = request.headers["Authorization"]?
    if auth_header
      auth_header.match(/Token\s+(?<jwt>.*)/).try(&.named_captures["jwt"])
    end
  end
end
