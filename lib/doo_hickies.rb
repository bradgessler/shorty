module DooHickies
  # Fun redirect DSL; I love how you can say redirect '/' => 'http://whatever.com'
  def redirect(route={})
    get route.keys.first do
      redirect route.values.first
    end
  end
  
  def random_key
    # Base 64 is fantastic except for the =, \, +, and / characters. Base62 anybody?
    ActiveSupport::SecureRandom.base64(4).gsub(/\=|\\|\+|\//,'')
  end
end

include DooHickies