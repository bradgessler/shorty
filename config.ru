require 'rack/cascade'
require 'shorty/model.rb'
require 'shorty/root_redirect.rb'
require 'shorty/core.rb'
require 'shorty/ui.rb'

use Rack::Cascade do |c|
  c.add Shorty::RootRedirect, "http://www.polleverywhere.com/"
  c.add Shorty::Core
  c.add Short::UI # Remove this if you want to run Shorty headless
end