class UserUpdateForm < User::BaseForm
  # Change password validations in src/forms/mixins/password_validations.cr
  include PasswordValidations

  fillable email
  virtual password : String
  fillable username
  fillable image
  fillable bio

  def prepare
    validate_uniqueness_of email
    validate_required username
    run_password_validations
    Authentic.copy_and_encrypt password, to: encrypted_password
  end
end
