module DooHickies
  # Fun redirect DSL; I love how you can say redirect '/' => 'http://whatever.com'
  def redirect(route={})
    get route.keys.first do
      redirect route.values.first
    end
  end
end

include DooHickies