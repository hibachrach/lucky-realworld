class UserBox < Avram::Box
  def initialize
    email "test@example.com"
    username "test.example"
    encrypted_password Authentic.generate_encrypted_password("password")
  end

  def password(unencrypted_password)
    encrypted_password Authentic.generate_encrypted_password(unencrypted_password)
  end
end
