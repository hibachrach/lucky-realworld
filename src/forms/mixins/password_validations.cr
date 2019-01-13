module PasswordValidations
  private def run_password_validations
    validate_required password
    validate_size_of password, min: 6
  end
end
