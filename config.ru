require 'rubygems'
require 'bundler'
Bundler.setup

require 'rack/cascade'
require 'shorty'

run Rack::Cascade.new([
  Shorty::RootRedirect.new('http://www.polleverywhere.com/'),
  Shorty::UI,
  Shorty::Core
])