ResourceController::ActionOptions.class_eval do  
  reader_writer  :flash_error
  reader_writer  :flash_now_error
  reader_writer  :flash_success
  reader_writer  :flash_now_success
  
  def dup
    returning self.class.new do |duplicate|
      duplicate.instance_variable_set(:@collector, wants.dup)
      duplicate.instance_variable_set(:@before, before.dup)                       unless before.nil?
      duplicate.instance_variable_set(:@after, after.dup)                         unless after.nil?
      duplicate.instance_variable_set(:@flash, flash.dup)                         unless flash.nil?
      duplicate.instance_variable_set(:@flash_now, flash_now.dup)                 unless flash_now.nil?
      duplicate.instance_variable_set(:@flash_success, flash_success.dup)         unless flash_success.nil?
      duplicate.instance_variable_set(:@flash_now_success, flash_now_success.dup) unless flash_now_success.nil?
      duplicate.instance_variable_set(:@flash_error, flash_error.dup)             unless flash_error.nil?
      duplicate.instance_variable_set(:@flash_now_error, flash_now_error.dup)     unless flash_now_error.nil?
    end
  end
  
end

ResourceController::FailableActionOptions.class_eval do
  delegate :flash_success, :flash_now_success, :flash_error, :flash_now_errors, :to => :success
end

ResourceController::Helpers::Internal.class_eval do
  
  protected
  
  def set_flash(action)
    set_normal_flash(action)
    set_flash_now(action)
    set_normal_flash_success(action)
    set_flash_now_success(action)
    set_normal_flash_error(action)
    set_flash_now_error(action)
  end

  def set_normal_flash_success(action)
    if f = options_for(action).flash_success
      flash[:success] = f.is_a?(Proc) ? instance_eval(&f) : options_for(action).flash_success
    end
  end

  def set_flash_now_success(action)
    if f = options_for(action).flash_now_success
      flash.now[:success] = f.is_a?(Proc) ? instance_eval(&f) : options_for(action).flash_now_success
    end
  end        
  
  def set_normal_flash_error(action)
    if f = options_for(action).flash_error
      flash[:error] = f.is_a?(Proc) ? instance_eval(&f) : options_for(action).flash_error
    end
  end

  def set_flash_now_error(action)
    if f = options_for(action).flash_now_error
      flash.now[:error] = f.is_a?(Proc) ? instance_eval(&f) : options_for(action).flash_now_error
    end
  end
  
end