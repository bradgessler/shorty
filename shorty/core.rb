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

    # If you PUT then you are defining the path!
    put '/:path' do
      halt [ 409, "#{url(params[:path])} has been taken" ] if Url.get(params[:path])
      @url = Url.new(:url => request.body.read.chomp, :path => params[:path])
      shorten_url
    end

    # If you post, we'll pick the path for you! This is here for curlability.
    post '/' do
      @url = Url.new(:url => request.body.read.chomp, :path => Url.random_path)
      shorten_url
    end

    get '/path/random' do
      Url.random_path
    end

    get '/:path' do
      if @url = Url.get(params[:path])
        redirect @url.url
      else
        halt 404, "Eh?"
      end
    end

  protected
    # Tries to save the url
    def shorten_url
      if @url.save
        headers 'Location' => url(@url.path)
        halt 201, "Created #{url(@url.path)}"
      else
        halt 406, "#{@url.errors.full_messages.join(".\n")}"
      end
    end
  end
end
