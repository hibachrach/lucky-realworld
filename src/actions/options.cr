class OptionsAction < ApiAction
  macro options
    setup_call_method({{ yield }})
  end

  options do
    head 200
  end
end
