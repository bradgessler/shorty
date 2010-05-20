require 'sinatra'

module Shorty
  class Core < Sinatra::Base
    helpers do
      def url(path)
        "http://#{host_name}/#{path}"
      end
      
      def host_name
        env['HTTP_HOST']
      end
    end
    
    # If you PUT then you are defining the key!
    put '/:key' do
      halt [ 409, "#{url(params[:key])} has been taken" ] if Url.get(params[:key])
      @url = Url.new(:url => request.body.read.chomp, :key => params[:key])
      shorten_url
    end

    # If you post, we'll pick the key for you! This is here for curlability.
    post '/' do
      @url = Url.new(:url => request.body.read.chomp, :key => Url.random_key)
      shorten_url
    end

    get '/key/random' do
      Url.random_key
    end

    get '/:key' do
      if @url = Url.get(params[:key])
        redirect @url.url
      else
        halt 404, "Eh?"
      end
    end
    
  protected
    # Tries to save the url
    def shorten_url
      if @url.save
        headers 'Location' => url(@url.key)
        halt 201, "Created #{url(@url.key)}"
      else
        halt 406, "URL or Key format is invalid"
      end
    end
  end
end
