require 'rubygems'
require 'bundler'
Bundler.setup

require 'shorty'

run Rack::Cascade.new([
  Shorty::RootRedirect.new('http://www.polleverywhere.com/vote'),
  Shorty::UI,
  Shorty::Core
])