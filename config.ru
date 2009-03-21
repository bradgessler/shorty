require 'bggd.rb'
# Middlewares
use Rack::MethodOverride
# Run it!
run Sinatra::Application