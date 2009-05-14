module Shorty
  class RootRedirect
    def initialize(app, url='/new', status=302)
      @app, @url = app
    end
    
    def call(env)
      if env['REQUEST_PATH'] == '/' and env['REQUEST_METHOD'] == 'GET'
        [status, {'Content-Type' => 'text/html', 'Location' => url}, url]
      else
        @app.call(env)
      end
    end
  end
end