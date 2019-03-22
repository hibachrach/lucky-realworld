require "../../../spec_helper.cr"
require "http/client/response"
require "json"
require "jwt"

client = HTTPClient.new
secret_key = Lucky::Server.settings.secret_key_base

Spec.after_each do
  client.sign_out!
end

describe Api::User::Update do
  acceptable_params = {
    "user" => {
      "email" => "updated.email@domain.com",
      "username" => "updated.username",
      "password" => "updatedPassw0rd!",
      "bio" => "updated bio",
      "image" => "updated image"
    }
  }

  context "with all acceptable params" do
    params = acceptable_params

    context "when signed in" do
      it "responds with serialized user info and updates the user" do
        user = UserBox.create
        client.sign_in!(as: user)

        response = client.put(path: Api::User::Update.url, body: params)
        response.status_code.should eq(200)
        response_body = JSON.parse(response.body)
        response_body["user"]["email"].should eq(params["user"]["email"])
        response_body["user"]["username"].should eq(params["user"]["username"])
        response_body["user"]["bio"].as_s.should eq(params["user"]["bio"])
        response_body["user"]["image"].as_s.should eq(params["user"]["image"])
        jwt = response_body["user"]["token"].as_s

        # This should not raise, i.e., it should be a valid JWT
        JWT.decode(jwt, secret_key, "HS256")

        user = UserQuery.new.email(params["user"]["email"]).first
        Authentic.correct_password?(user, params["user"]["password"]).should be_truthy
      end
    end

    context "when not signed in" do
      it "responds unauthorized" do
        UserBox.create

        response = client.put(path: Api::User::Update.url, body: params)
        response.status_code.should eq(401)
      end
    end
  end
end
