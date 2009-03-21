require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'activesupport'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://my.db')

module Bggd
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
  
  validates_format :as => :url
  validates_is_unique :key
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
    "Oops"
  end
end

post '/' do
  @url = Url.new(:url => params[:url], :key => Bggd.random)
end

get '/new' do
  @key = Bggd.random
  haml :new
end

get '/:key' do
  "#{params[:key]}"
end