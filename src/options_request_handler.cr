class OptionsRequestHandler(T)
  include HTTP::Handler

  private getter action

  def initialize(@action : T)
  end

  def call(context)
    if context.request.method.upcase == "OPTIONS"
      Lucky.logger.debug("Handled by #{action.to_s.colorize.bold}")
      action.new(context, {} of String => String).perform_action
    else
      call_next(context)
    end
  end
end
