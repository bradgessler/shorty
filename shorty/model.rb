require 'dm-core'         # sudo gem install dm-core
require 'dm-validations'  # sudo gem install dm-more
require 'active_support'  # sudo gem install activesupport
require 'anybase'

# Database settings. The DATABASE_URL stuff is used by Heroku
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/shorty.db")

module Shorty
  class Url
    include DataMapper::Resource
    
    IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
    URL_REGEXP = %r{
      \A
      https?://                                        # http:// or https://
      ([^\s:@]+:[^\s:@]*@)?                            # optional username:pw@
      ( (xn--)?[^\W_]+([-.][^\W_]+)*\.[a-z]{2,6}\.? |  # domain (including Punycode/IDN)...
          #{IPv4_PART}(\.#{IPv4_PART}){3} )            # or IPv4
      (:\d{1,5})?                                      # optional port
      ([/?]\S*)?                                       # optional /whatever or ?whatever
      \Z
    }iux
    
    property :url, String, :length => 2024 # ~ 2 kilobytes, thats one BIG url! Bigger than what IE can handle!
    property :path, String, :index => true, :key => true, :length => 64
    
    validates_present :url
    validates_format :url, :as => URL_REGEXP
    validates_format :path, :as => /^[-_a-z0-9]+$/i  # I only want to allow alpha, nums, _, and - in the URL key
    validates_is_unique :path
    
    def self.random_path
      Anybase::Base62.random(path_size)
    end
    
    def self.path_size
      8
    end
  end
end