namespace :kiki do
  
  namespace :generate do
    
    desc "Creates Skeleton for Kiki app"
    task :app => :environment do |t,args|
      app_name = args['name']
      if app_name.to_s.empty?
        puts "Please provide name like 'rake kiki:generate:app name=proba'"
      else
        puts "* Creating Kiki Application in 'public/kiki/apps/#{app_name}'"
        puts "APPS_ROOT #{Kiki.apps_root}"
        #copy_directory "#{RAILS_ROOT}/vendor/plugins/kiki/assets/javascripts/kiki/blank_app", "#{KIKI_APPS_ROOT}/#{name}"
      end
    end
    
    desc "Creates kiki controller, helper, and view"
    task :view => :environment do |t,args|     
      name = args['name']
      force = args['force'] ? true : false
      if name.to_s.empty?
        puts "Please provide name like name=my_view"
      else
        app = args['app'] || File.basename(RAILS_ROOT)
        create_file("#{Kiki.apps_root}/#{app}/views/#{name}.js", "Views.#{name.camelize} = function() {\n\tViews.#{name.camelize}.superclass.constructor.call(this);\n\n\tthis.layout = function() {};\n\n};\nKiki.extend.view('#{name.camelize}');", :force => force)
        create_file("#{Kiki.apps_root}/#{app}/helpers/#{name}_helper.js", "Helpers.#{name.camelize} = function() {\n\tHelpers.#{name.camelize}.superclass.constructor.call(this);\n\n\n};\nKiki.extend.helper('#{name.camelize}');", :force => force)
        create_file("#{Kiki.apps_root}/#{app}/controllers/#{name}_controller.js", "Controllers.#{name.camelize} = function() {\n\tControllers.#{name.camelize}.superclass.constructor.call(this);\n\n\n};\nKiki.extend.controller('#{name.camelize}');", :force => force)
      end      
    end
    
    desc "Creates kiki model"
    task :model => :environment do |t,args|
      name = args['name']
      force = args['force'] ? true : false
      if name.to_s.empty?
        puts "Please provide name like name=my_model"
      else
        app = args['app'] || File.basename(RAILS_ROOT)
        create_file("#{Kiki.apps_root}/#{app}/models/#{name}.js", "Models.#{name.camelize} = function() {\n\tModels.#{name.camelize}.superclass.constructor.call(this);\n\n\tthis.columns = [];\n\n};\n#{name.camelize} = Kiki.extend.model('#{name.camelize}');", :force => force)
      end      
    end
    
  end
  
  # creates file with content
  def create_file(path, content, options={})
    create = true
    if File.exists?(path)
      create = false
      if options[:force]
          File.delete(path)
          create = true
      end
    end
    if create
      File.open(path, "w") { |f| f.write content }
      puts "\tcreated #{path}"
    else
      puts "\texist #{path}"
    end
  end
  
end