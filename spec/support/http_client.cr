class HTTPClient < Lucky::BaseHTTPClient
  def initialize(port = ENV["TEST_PORT"].to_i)
    @client = HTTP::Client.new(Lucky::Server.settings.host, port: port)
  end

  def get(path : String, headers : HTTP::Headers? = nil, params : Object? = nil)
    body = params.try(&.to_json)
    @client.get(path, headers: set_as_json(headers), body: body)
  end

  {% for method in [:put, :patch, :post] %}

    def {{method.id}}(path : String, body : Object, headers : HTTP::Headers? = nil)
      body = body.try(&.to_json)
      @client.{{method.id}}(path, headers: set_as_json(headers), body: body)
    end

  {% end %}

  private def set_as_json(headers : HTTP::Headers? = nil)
    headers = headers || HTTP::Headers.new
    headers["Content-Type"] = "application/json"
    headers
  end
end
