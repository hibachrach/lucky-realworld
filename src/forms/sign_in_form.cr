class SignInForm < Avram::VirtualForm
  include FindAuthenticatable

  virtual email : String
  virtual password : String

  # This method is called to allow you to determine if a user can sign in.
  # By default it validates that the user exists and the password is correct.
  #
  # If desired, you can add additional checks in this method, e.g.
  #
  #    if user.locked?
  #      email.add_error "is locked out"
  #    end
  private def validate_credentials(user : User?)
    if user
      unless Authentic.correct_password?(user, password.value.to_s)
        password.add_error "is wrong"
      end
    else
      email.add_error "is not in our system"
    end
  end

  def submit! : User
    validate_required(email)
    validate_required(password)
    user = find_authenticatable
    validate_credentials(user)

    if user && valid?
      user
    else
      raise Avram::InvalidFormError.new(form: self)
    end
  end
end
