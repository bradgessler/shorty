require 'rubygems'
require 'sinatra'
require 'dm-core'         # sudo gem install dm-core
require 'dm-validations'  # sudo gem install dm-more
require 'activesupport'   # sudo gem install activesupport
require 'lib/doo_hickies'

# Database settings. The DATABASE_URL stuff is used by Heroku
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/shorty.db")

# What do you want to do with the root URL? Personally, I want it to
# redirect to http://bradgessler.com
redirect '/' => '/new'

# Ok, you probably don't need to change anything beyond this point! You can
# stop unless you're feeling like superman.

# The data model doesn't get any stupider than this folks!
class Url
  include DataMapper::Resource
  
  property :url, String, :length => 2024 # 2 kilobytes, thats one BIG url!
  property :key, String, :index => true, :key => true, :length => 64
  
  validates_is_unique :key
  validates_is_unique :url
  
  validates_format :url, :as => :url
  # I only want to allow alpha, nums, _, and - in the URL key
  validates_format :key, :as => /^[-_a-z0-9]+$/i
end

template :layout

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

# If you PUT then you are defining the key!
put '/' do
  @url = Url.new(:url => params[:url], :key => params[:key])
  
  if @url.save
    redirect "/#{@url.key}/show"
  else
    status 406 # Unacceptable!
    haml :new
  end
end

# If you post, we'll pick the key for you! This is here for curlability.
post '/' do
  @url = Url.new(:url => params[:url], :key => random_key)
  
  if @url.save
    redirect "/#{@url.key}"
  else
    status 406 # Unacceptable!
    haml :new
  end
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