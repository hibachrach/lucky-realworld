require "../../../spec_helper.cr"
require "http/client/response"
require "json"

client = HTTPClient.new

Spec.after_each do
  client.sign_out!
end

email = "jane@doe.com"
password = "passW0rd!"
username = "jane.doe"
bio = "my bio"
image = "an image"

create_user = ->() do
  UserBox.create(
    &.email(email)
    .password(password)
    .username(username)
    .bio(bio)
    .image(image)
  )
end

describe Api::Follows::Delete do
  context "when following the user" do
    it "unfollows the user and responds with serialized profile info" do
      user = create_user.call
      # Signed in as the user we're investigating, but that doesn't matter
      client.sign_in!(as: user)

      FollowForm.create!(follower_id: user.id, followed_id: user.id)

      response = client.delete(path: Api::Follows::Delete.with(username: user.username).url)
      response.status_code.should eq(200)
      response_body = JSON.parse(response.body)
      response_body["user"]["username"].should eq(username)
      response_body["user"]["bio"].as_s.should eq(bio)
      response_body["user"]["image"].as_s.should eq(image)
      response_body["user"]["following"].as_bool.should be_false

      FollowQuery.new.follower_id(user.id).followed_id(user.id).first?.should be_nil
    end
  end
end
