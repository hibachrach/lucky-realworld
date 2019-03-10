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
require "./services/**"
require "../config/env"
require "../config/**"
require "../db/migrations/**"

class App < Lucky::BaseApp
  def middleware
    [
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
end
