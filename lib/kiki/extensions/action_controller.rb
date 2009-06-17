ActionController::Base.class_eval do
    
  private

  def render_kiki_json(options={})
   default_options = { :success => true, :flash => flash }
   status = options.delete(:status) || :ok
   render :json => default_options.merge(options), :status => status
  end
    
end