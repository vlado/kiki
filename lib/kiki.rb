require 'kiki/core_ext'
require 'kiki/active_record_ext'

module Kiki
  
  @@version = "0.0.1"
  @@path = "#{RAILS_ROOT}/public/javascripts/kiki"
  
  class << self
  
    def version
      @@version
    end
    
    def version=(version)
      @@version = version
    end
  
    def path
      @@path
    end      
    
    def path=(path)
      @@path = path
    end
    
    def root
      "#{@@path}/releases/#{@@version}"
    end
    
    def apps_root
      "#{RAILS_ROOT}/public/javascripts/apps"
    end
    
    def web_root
      root.gsub("#{RAILS_ROOT}/public", "")
    end
    
    def apps_web_root
      apps_root.gsub("#{RAILS_ROOT}/public", "")
    end
    
  end
  
end