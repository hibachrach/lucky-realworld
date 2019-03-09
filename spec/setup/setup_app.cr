app = App.new

spawn do
  Lucky::Server.temp_config(port: ENV["TEST_PORT"].to_i) do
    puts "Starting to listen at #{app.base_uri}..."
    app.listen
  end
end

at_exit do
  app.close
end
