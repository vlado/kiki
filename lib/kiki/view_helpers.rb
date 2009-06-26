module Kiki
  module ViewHelpers
    
    def include_extjs(options = {})
      default_options = {
        :adapter => :ext,
        :debug => RAILS_ENV=="production" ? false : true,
        :stylesheets => :all
      }
      opts = default_options.merge(options)
      files = Kiki::Ext.adapter_files_to_include[opts[:adapter]].collect { |f| "#{Kiki::Ext.web_root}/adapter/#{opts[:adapter]}/#{f}" }
      debug = opts[:debug] ? "-debug" : ""
      files << "#{Kiki::Ext.web_root}/ext-all#{debug}"
      if opts[:locale]
        files << "#{Kiki::Ext.web_root}/build/locale/ext-lang-#{opts[:locale]}-min"
      end
      css = opts[:stylesheets] ? "\n"+stylesheet_for_extjs(*opts[:stylesheets]) : ""
      javascript_include_tag(*files) + css
    end
    
    def stylesheet_for_extjs(*files)
      if files.to_a.empty? or files.to_s == "all"
        stylesheet_link_tag("#{Kiki::Ext.web_root}/resources/css/ext-all")
      else
        files = files.collect { |f| "#{Kiki::Ext.web_root}/resources/css/#{f}" }
        stylesheet_link_tag(*files)
      end
    end
    
    def include_kiki(options = {})
      default_options = { :stylesheets => :all }
      opts = default_options.merge(options)
      css = opts[:stylesheets] ? "\n"+stylesheet_for_kiki(*opts[:stylesheets]) : ""
      javascript_include_tag(*kiki_js_files_array) + css
    end
    
    def include_kiki_app(app, options = {})
      default_options = {
        :extjs => {},
        :kiki => {},
        :controller => params[:controller],
        :delay => 0
      }
      opts = default_options.merge(options)
      app_root = "#{Kiki.apps_root}/#{app}"
      app_web_root = "#{Kiki.apps_web_root}/#{app}"
      app_files = []
      app_files += Dir.files_with_extension("#{app_root}/models", "js").collect { |f| "models/#{f}" }
      app_files += ["controllers/application"]
      app_files += Dir.files_with_extension("#{app_root}/controllers", "js").delete_if { |f| !f.match(/controller\.js$/) }.collect { |f| "controllers/#{f}" }
      app_files += ["helpers/application"]
      app_files += Dir.files_with_extension("#{app_root}/helpers", "js").delete_if { |f| !f.match(/helper\.js$/) }.collect { |f| "helpers/#{f}" }
      app_files += Dir.files_with_extension("#{app_root}/views", "js").collect { |f| "views/#{f}" }
      
      data_from_rails = <<-JS
      AUTHENTICITY_TOKEN='#{form_authenticity_token}';
      CONTROLLER='#{opts[:controller].camelize}';
      FLASH=#{flash.to_json};
      JS
      
      data_from_kiki_plugin = <<-JS
      Ext.BLANK_IMAGE_URL='#{Kiki::Ext.web_root}/resources/images/default/s.gif';
      Kiki.EXTJS_ROOT='#{Kiki::Ext.web_root}';
      Kiki.ROOT='#{Kiki.web_root}';
      Kiki.ICONS_ROOT='#{Kiki.web_root}/resources/images/icons';
      Kiki.ENV='#{RAILS_ENV}'
      JS
      
      stylesheets = Dir.files_with_extension("#{app_root}/resources/stylesheets", "css").collect { |f| "#{app_web_root}/resources/stylesheets/#{f}" }
      
      kiki = include_extjs(opts[:extjs])
      kiki << "\n"+javascript_tag(data_from_rails)
      kiki << "\n"+include_kiki(opts[:kiki])
      kiki << "\n"+javascript_include_tag(*app_files.collect { |f| "#{app_web_root}/#{f}" })
      kiki << "\n"+stylesheet_link_tag(*stylesheets)
      kiki << "\n"+javascript_tag(data_from_kiki_plugin)
      kiki << "\n"+javascript_include_tag("#{Kiki.web_root}/init")
      kiki
    end
    
    def stylesheet_for_kiki(*files)
      if files.to_a.empty? or files.to_s == "all"
        files = Dir.files_with_extension("#{Kiki.root}/resources/css", "css").collect { |f| "#{Kiki.web_root}/resources/css/#{f}" }
        Dir.directories("#{Kiki.root}/ux").each do |dir|
          if File.exist?("#{Kiki.root}/ux/#{dir}/css")
            files += Dir.files_with_extension("#{Kiki.root}/ux/#{dir}/css", "css").collect { |f| "#{Kiki.web_root}/ux/#{dir}/css/#{f}" }
          end
        end
        stylesheet_link_tag(*files)
      else
        files = files.collect { |f| "#{Kiki.web_root}/resources/css/#{f}" }
        stylesheet_link_tag(*files)
      end
    end
    
    private
    
    def kiki_js_files_array
      files = ["lib/config/preload"]
      files += Dir.files_with_extension("#{Kiki.root}/lib/config/overrides", "js").collect { |f| "lib/config/overrides/#{f}" }
      Dir.directories("#{Kiki.root}/lib").delete_if { |e| e=="config" }.each do |dir|
        files += Dir.files_with_extension("#{Kiki.root}/lib/#{dir}", "js").collect { |f| "lib/#{dir}/#{f}" }
      end
      files += Dir.files_with_extension("#{Kiki.root}/plugins", "js").collect { |f| "plugins/#{f}" }
      Dir.directories("#{Kiki.root}/ux").each do |dir|
        files += Dir.files_with_extension("#{Kiki.root}/ux/#{dir}", "js").collect { |f| "ux/#{dir}/#{f}" }
      end
      files << "lib/config/postload"
      files << "lib/config/environment"
      files.collect { |f| "#{Kiki.web_root}/#{f}" }
    end
    
  end  
end