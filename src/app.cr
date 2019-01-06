require "./dependencies"
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./queries/mixins/**"
require "./queries/**"
require "./forms/mixins/**"
require "./forms/**"
require "./serializers/**"
require "./emails/base_email"
require "./emails/**"
require "./actions/mixins/**"
require "./actions/**"
require "../config/env"
require "../config/**"
require "../db/migrations/**"

class App
  private getter server

  def initialize
    @server = HTTP::Server.new [
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::LogHandler.new,

      # Disabled in API mode, but can be enabled if you need them:
      # Lucky::SessionHandler.new,
      # Lucky::FlashHandler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RouteHandler.new,

      # Disabled in API mode:
      # Lucky::StaticFileHandler.new("./public", false),
      Lucky::RouteNotFoundHandler.new,
    ]
  end

  def base_uri
    "http://#{host}:#{port}"
  end

  def host
    Lucky::Server.settings.host
  end

  def port
    Lucky::Server.settings.port
  end

  def listen
    server.bind_tcp host, port
    server.listen
  end

  def close
    server.close
  end
end
