require 'rubygems'
require 'sinatra'
require 'dm-core'         # sudo gem install dm-core
require 'dm-validations'  # sudo gem install dm-more
require 'activesupport'   # sudo gem install activesupport

# Database settings. The DATABASE_URL stuff is used by Heroku
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/shorty.db")

# What do you want to do with the root URL? Personally, I want it to
# redirect to http://bradgessler.com
set :root_redirect, '/new'

# The data model doesn't get any stupider than this folks!
class Url
  include DataMapper::Resource
  
  property :url, String, :length => 2024 # 2 kilobytes, thats one BIG url! Bigger than what IE can handle!
  property :key, String, :index => true, :key => true, :length => 64
  
  validates_present :url
  validates_format :url, :as => :url
  validates_is_unique :key
  validates_format :key, :as => /^[-_a-z0-9]+$/i  # I only want to allow alpha, nums, _, and - in the URL key
end

template :layout

helpers do
  def url(path)
    "http://#{host_name}/#{path}"
  end
  
  def host_name
    env['HTTP_HOST']
  end
  
  def random_key
    # Base 64 is fantastic except for the =, \, +, and / characters. Base62 anybody?
    ActiveSupport::SecureRandom.base64(4).gsub(/\=|\\|\+|\//,'')
  end
end

get '/' do
  redirect options.root_redirect
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

# If you PUT then you are defining the key!
put '/:key' do
  halt [ 409, "#{url(params[:key])} has been taken" ] if Url.get(params[:key])
  
  @url = Url.new(:url => request.body.read.chomp, :key => params[:key])
  
  if @url.save
    redirect url(@url.key), "Created #{url(@url.key)}"
  else
    halt 406, "URL or Key format is invalid"
  end
end

# If you post, we'll pick the key for you! This is here for curlability.
post '/' do
  @url = Url.new(:url => request.body.read.chomp, :key => random_key)
  
  if @url.save
    redirect url(@url.key), "Created #{url(@url.key)}"
  else
    halt 406, "URL or Key format is invalid"
  end
end

get '/key' do
  content_type 'text/plain', :charset => 'utf-8'
  random_key
end

get '/new' do
  @url = Url.new(:url => params[:url], :key => random_key)
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