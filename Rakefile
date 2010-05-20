require 'rubygems'
require 'bundler'
Bundler.setup

namespace :db do
  desc "Loads our environment for various tasks that need it"
  task :environment do
    require 'shorty/model'
    DataMapper::Logger.new($stdout, :debug)
  end
  
  desc "Migrate the database" # Convention for Heroku
  task(:migrate => :environment) do
    DataMapper.auto_upgrade!
  end
end