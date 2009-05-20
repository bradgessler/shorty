require 'rubygems'
require 'haml'
require 'sinatra'

module Shorty
  class UI < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '/ui'))
    set :static, true
    
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
      # TODO make this random key come from core via an AJAX call 
      # from /key. Look at core.rb to see how that thing works.
      @url = Url.new(:url => params[:url], :key => 'random_key')
      haml :show
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