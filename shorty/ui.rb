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
      @url = Url.new(:url => params[:url], :path => Url.random_path)
      haml :show
    end
    
    get '/:path/show' do
      if @url = Url.get(params[:path])
        haml :show
      else
        halt 404, "Huh?"
      end
    end
    
    get '/:path' do
      if @url = Url.get(params[:path])
        redirect @url.url
      else
        halt 404, "Eh?"
      end
    end
  end
end