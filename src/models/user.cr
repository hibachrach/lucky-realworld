class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table :users do
    column email : String
    column encrypted_password : String
    column username : String
    column bio : String?
    column image : String?
  end

  def emailable
    Carbon::Address.new(email)
  end
end
