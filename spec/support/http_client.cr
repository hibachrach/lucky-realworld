class HTTPClient < Lucky::BaseHTTPClient
  private getter persistent_headers = HTTP::Headers{ "Content-Type" => "application/json" }

  def initialize(port = ENV["TEST_PORT"].to_i)
    @client = HTTP::Client.new(Lucky::Server.settings.host, port: port)
  end

  def sign_in!(as user)
    jwt = JwtService.token(user)
    persistent_headers.add("Authorization", "Token #{jwt}")
  end

  def sign_out!
    persistent_headers.delete("Authorization")
  end

  def get(path : String, headers : HTTP::Headers? = nil, params : Object? = nil)
    body = params.try(&.to_json)
    @client.get(path, headers: add_persistent_headers(headers), body: body)
  end

  {% for method in [:put, :patch, :post] %}

    def {{method.id}}(path : String, body : Object? = nil, headers : HTTP::Headers? = nil)
      body = body.try(&.to_json)
      @client.{{method.id}}(path, headers: add_persistent_headers(headers), body: body)
    end

  {% end %}

  def delete(path : String, headers : HTTP::Headers? = nil, params : Object? = nil)
    body = params.try(&.to_json)
    @client.delete(path, headers: add_persistent_headers(headers), body: body)
  end


  private def add_persistent_headers(headers : HTTP::Headers? = nil)
    headers = headers.dup || HTTP::Headers.new
    headers.merge!(persistent_headers)
    headers
  end
end
