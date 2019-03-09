require "../../../spec_helper.cr"
require "http/client/response"
require "json"
require "jwt"

client = HTTPClient.new
secret_key = Lucky::Server.settings.secret_key_base

describe Api::Users::Create do
  required_params = {
    "user" => {
      "email" => "jane@doe.com",
      "username" => "jane@doe.com",
      "password" => "passW0rd!",
    }
  }

  context "with all required params" do
    params = required_params

    it "responds with serialized user info" do
      response = client.post(path: Api::Users::Create.url, body: params)
      response.status_code.should eq(201)
      response_body = JSON.parse(response.body)
      response_body["user"]["email"].should eq(params["user"]["email"])
      response_body["user"]["username"].should eq(params["user"]["username"])
      response_body["user"]["bio"].as_nil.should be_nil
      response_body["user"]["image"].as_nil.should be_nil
      jwt = response_body["user"]["token"].as_s

      # This should not raise, i.e., it should be a valid JWT
      JWT.decode(jwt, secret_key, "HS256")
    end
  end

  ["email", "username", "password"].each do |required_param|
    context "missing #{required_param}" do
      params = { "user" => required_params["user"].reject(required_param) }

      it "responds with serialized user info" do
        response = client.post(path: Api::Users::Create.url, body: params)
        response.status_code.should eq(422)
      end
    end
  end
end
