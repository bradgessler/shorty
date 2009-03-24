require 'rubygems'
require 'sinatra'
require 'dm-core'         # sudo gem install dm-core
require 'dm-validations'  # sudo gem install dm-more
require 'activesupport'   # sudo gem install activesupport

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/shorty.db")

module Shorty
  class << self
    def random
      ActiveSupport::SecureRandom.base64(4).gsub(/\=|\\|\+|\//,'')
    end
  end
end

class Url
  include DataMapper::Resource
  
  property :url, String, :length => 8192 # 8 kilobytes
  property :key, String, :index => true, :key => true, :length => 64
  
  validates_is_unique :key
  validates_is_unique :url
  
  validates_format :url, :as => :url
  validates_format :key, :as => /^[-_a-z0-9]+$/i
end

template :layout

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/' do
  redirect '/new'
end

put '/' do
  @url = Url.new(:url => params[:url], :key => params[:key])
  
  if @url.save
    redirect "/#{@url.key}/show"
  else
    haml :new
  end
end

get '/new' do
  @url = Url.new(:url => params[:url], :key => Shorty.random)
  haml :new
end

get '/:key/show' do
  if @url = Url.get(params[:key])
    haml :show
  else
    halt 404, "Huh?"
  end
end

get '/:key' do
  if @url = Url.get(params[:key])
    redirect @url.url
  else
    halt 404, "Eh?"
  end
end