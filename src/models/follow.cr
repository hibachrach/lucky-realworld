require "./user"

class Follow < BaseModel
  table :follows do
    belongs_to follower : User
    belongs_to followed : User
  end
end
