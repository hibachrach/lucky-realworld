require "../../../spec_helper.cr"
require "http/client/response"

client = HTTPClient.new
secret_key = Lucky::Server.settings.secret_key_base

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

describe Api::Sessions::Create do
  required_params = {
    "user" => {
      "email" => email,
      "password" => password,
    }
  }

  context "with all required params" do
    params = required_params

    context "with correct email and password" do
      it "responds with serialized user info" do
        create_user.call
        response = client.post(path: Api::Sessions::Create.url, body: params)
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

    context "with email not in database" do
      params = { "user" => required_params["user"].merge({ "email" => "not-in-database@example.com" }) }

      it "responds with 422 and error message" do
        create_user.call
        response = client.post(path: Api::Sessions::Create.url, body: params)
        response.status_code.should eq(422)
        response_body = JSON.parse(response.body)
        response_body["errors"]["email"][0].as_s.should eq("is not in our system")
      end
    end

    context "with incorrect password" do
      params = { "user" => required_params["user"].merge({ "password" => "wrong password" }) }

      it "responds with 422 and error message" do
        create_user.call
        response = client.post(path: Api::Sessions::Create.url, body: params)
        response.status_code.should eq(422)
        response_body = JSON.parse(response.body)
        response_body["errors"]["password"][0].as_s.should eq("is wrong")
      end
    end

    context "with incorrect password" do
      params = { "user" => required_params["user"].merge({ "password" => "wrong password" }) }

      it "responds with 422 and error message" do
        create_user.call
        response = client.post(path: Api::Sessions::Create.url, body: params)
        response.status_code.should eq(422)
        response_body = JSON.parse(response.body)
        response_body["errors"]["password"][0].as_s.should eq("is wrong")
      end
    end
  end

  ["email", "password"].each do |required_param|
    context "missing #{required_param}" do
      params = { "user" => required_params["user"].reject(required_param) }

      it "responds with serialized user info" do
        response = client.post(path: Api::Sessions::Create.url, body: params)
        response.status_code.should eq(422)
        response_body = JSON.parse(response.body)
        response_body["errors"][required_param][0].as_s.should eq("is required")
      end
    end
  end
end
