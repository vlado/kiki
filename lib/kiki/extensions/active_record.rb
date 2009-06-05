class ActiveRecord::Base
  
  class << self

    def search_in_columns(query, columns, options={})
      options[:conditions] = Kiki::Util.conditions_for_search_in_columns(query, columns)
      results = self.find(:all, options)
    end

  end
  
  def errors_for_kiki
    self.errors.collect { |attrib, msg| { :id => attrib, :msg => msg } }
  end
  
end

# See config/initializers/new_rails_defaults for more info
# ActiveRecord::Base.include_root_in_json = false