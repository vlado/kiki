class Dir
  
  class << self
    
    def files_with_extension(dir, extension)
      re = Regexp.compile("(#{extension})$")
      Dir.entries(dir).delete_if { |e| File.directory?("#{dir}/#{e}") or !e.match(re) }
    end
    
    def directories(dir)
      Dir.entries(dir).delete_if { |e| !File.directory?("#{dir}/#{e}") or e == "." or e == ".." }
    end
    
  end
  
end