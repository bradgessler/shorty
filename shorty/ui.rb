require 'rubygems'
require 'haml'
require 'sinatra'

module Shorty
  class UI < Sinatra::Base
    template :layout
    
    use_in_file_templates!
    
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

__END__
@@ layout
!!!
!!! xml
%html
  %head
    %title shorty
    %link{:href=>'/stylesheet.css',:rel=>'stylesheet',:type=>'text/css'}
    %script{:type=>'text/javascript',:src=>'/prototype-1.6.0.3.js'}
  %body
    .wrapper.outter
      #header
        .wrapper.inner
          %h1 shorty
          %h2 A tiny URL shortner
      #main
        .wrapper.inner
          =yield
      #footer
        .wrapper.inner

@@ show
%form#shortener{:method=>'post',:action=>'/'}
  %input{:type=>'hidden',:name=>'_method',:value=>'put'}
  ="http://#{@env['HTTP_HOST']}/"
  %input#key.faux{:type=>'text',:name=>'key',:value=>@url.key,:tabindex=>2,:size=>8}>
  &#10132;
  %input#url{:type=>'text',:name=>'url',:value=>@url.url,:tabindex=>1,:size=>35}
  %input#shorten{:type=>'submit',:value=>'Shorten',:tabindex=>3}
#status
:javascript
  $('shortener').observe('submit', function(e){
    var url = '/' + $('key').value;
    alert(url);
    new Ajax.Request(url, {
      method: 'put',
      contentType: 'text/plain',
      postBody: $('url').value,
      onComplete: function(xhr) {
        alert(xhr.status);
      }
    });
    e.stop();
  });
  
@@ stylesheet
body
  :background #fff
  :border-top 10px solid #f00
body, input
  :font
    :family Helvetica
    :size 1em
  :margin 0
input.faux
  :border none
.wrapper.outter
  :padding 2em
#main
  :margin 10em 0
  :font-size 1.25em
  #status
    :padding 0.5em 0
    &.error
      :color #f00
    &.ok
      :color #0f0
#header
  h1
    :display inline
    :font
      :size 1em
    :color #f00
    :margin 0
    :padding 0
  h2
    :display inline
    :font
      :size 0.75em
      :weight normal
    :color #999
    :margin 0
    :padding 0