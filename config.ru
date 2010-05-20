require 'rubygems'
require 'bundler'
Bundler.setup

require 'shorty'

run Rack::Cascade.new([
  Shorty::RootRedirect.new('http://www.polleverywhere.com/'),
  Shorty::UI,
  Shorty::Core
])