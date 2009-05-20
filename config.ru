require 'rack/cascade'
require 'shorty'

run Rack::Cascade.new([
  Shorty::RootRedirect.new,
  Shorty::UI,
  Shorty::Core
])