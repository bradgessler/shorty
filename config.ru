require 'rack/cascade'
require 'shorty/model.rb'
require 'shorty/root_redirect.rb'
require 'shorty/core.rb'
require 'shorty/ui.rb'

run Rack::Cascade.new([
  Shorty::RootRedirect.new('http://www.polleverywhere.com/'),
  Shorty::UI,
  Shorty::Core
])