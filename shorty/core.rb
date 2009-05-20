require 'rubygems'
require 'sinatra'
require 'activesupport'   # sudo gem install activesupport

module Shorty
  class Core < Sinatra::Base
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

    get '/:key' do
      debugger
      if @url = Url.get(params[:key])
        redirect @url.url
      else
        halt 404, "Eh?"
      end
    end
  end
end
