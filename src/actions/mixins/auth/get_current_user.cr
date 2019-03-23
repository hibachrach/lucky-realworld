module Auth::GetCurrentUser
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
