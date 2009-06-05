module Kiki
  module Ext
    
    @@version = "2.2.1"
    @@path = "#{RAILS_ROOT}/public/javascripts/extjs"
    @@adapter_files_to_include = {
      :ext => ["ext-base"],
      :jquery => ["jquery", "ext-jquery-adapter"],
      :prototype => ["prototype", "scriptaculous.js?load=effects", "ext-prototype-adapter"],
      :yui => ["yui-utilities", "ext-yui-adapter"]
    }
    
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
      
      def web_root
        root.gsub("#{RAILS_ROOT}/public", "")
      end
      
      def adapter_files_to_include
        @@adapter_files_to_include
      end
      
    end
    
  end
end