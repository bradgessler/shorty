require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'activesupport'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/bggd.db")
DataMapper.auto_migrate!

module Token
  class << self
    def random
      ActiveSupport::SecureRandom.base64(4).gsub(/\=|\\|\+|\//,'')
    end
  end
end

class Url
  include DataMapper::Resource
  
  property :url, String
  property :key, String, :index => true, :key => true
  
  validates_is_unique :key
  validates_is_unique :url
  
  validates_format :url, :as => :url
  validates_format :key, :as => /^[a-z0-9]+$/i
end

template :layout

get '/' do
  redirect 'http://bradgessler.com/'
end

put '/' do
  @url = Url.new(:url => params[:url], :key => params[:key])
  
  if @url.save
    redirect @url.url
  else
    haml :new
  end
end

post '/' do
  @url = Url.new(:url => params[:url], :key => Token.random)
end

get '/new' do
  @url = Url.new(:url => params[:url], :key => Token.random)
  haml :new
end

get '/:key' do
  "#{params[:key]}"
end