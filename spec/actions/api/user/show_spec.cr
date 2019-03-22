require "../../../spec_helper.cr"
require "http/client/response"
require "json"
require "jwt"

client = HTTPClient.new
secret_key = Lucky::Server.settings.secret_key_base

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

describe Api::User::Show do
  context "when signed in" do
    it "responds with serialized user info" do
      user = create_user.call
      client.sign_in!(as: user)

      response = client.get(path: Api::User::Show.url)
      response.status_code.should eq(200)
      response_body = JSON.parse(response.body)
      response_body["user"]["email"].should eq(email)
      response_body["user"]["username"].should eq(username)
      response_body["user"]["bio"].as_s.should eq(bio)
      response_body["user"]["image"].as_s.should eq(image)
      jwt = response_body["user"]["token"].as_s

      # This should not raise, i.e., it should be a valid JWT
      JWT.decode(jwt, secret_key, "HS256")
    end
  end

  context "when not signed in" do
    it "responds with serialized user info" do
      create_user.call
      response = client.get(path: Api::User::Show.url)
      response.status_code.should eq(401)
    end
  end
end
