require 'rubygems'
require 'sinatra'
 
disable :run
set :environment, :production
set :raise_errors, true
set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'
set :app_file, __FILE__
 
log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
 
require 'bggd.rb' # contains my application
run Sinatra.application