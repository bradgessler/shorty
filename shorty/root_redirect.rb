module Shorty
  class RootRedirect
    def initialize(url='/new', status=302)
      @url, @status = url, status
    end
    
    def call(env)
      if env['REQUEST_PATH'] == '/' and env['REQUEST_METHOD'] == 'GET'
        [ @status, { 'Content-Type' => 'text/html', 'Location' => @url }, @url ]
      else
        [ 404, { 'Content-Type' => 'text/html' }, '']
      end
    end
  end
end