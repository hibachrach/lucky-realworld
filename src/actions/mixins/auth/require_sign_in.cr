module Auth::RequireSignIn
  include Auth::GetCurrentUser

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
end
