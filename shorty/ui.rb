require 'rubygems'
require 'sinatra'

module Shorty
  class UI < Sinatra::Base
    template :layout
    
    helpers do
      def url(path)
        "http://#{host_name}/#{path}"
      end
      
      def host_name
        env['HTTP_HOST']
      end
    end
    
    get '/stylesheet.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :stylesheet
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
  end
end