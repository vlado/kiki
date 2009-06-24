module Kiki
  module Util
  
    class << self
      
      # '["one","two","three"]' => ["one", "two", "three"]
      def real_array_from_string_array(string_array)
        string_array.to_s.empty? ? [] : string_array.to_s.gsub(/(^\[|\]$)/, "").gsub(/(^"|"$)/, "").split('","')
      end
      
      def conditions_for_search_in_columns(query, columns)
        wild_query = "%#{query}%" unless query.to_s.match(/(^%|%$)/)
        conditions = ["", { :query => query, :wild_query => wild_query }]
        if columns.to_a.empty?
          conditions = nil
        else
          conditions[0] = columns.collect { |c| (c == "id" ? "#{c} = :query" : "#{c} like :wild_query") }.join(" OR ")
        end
        conditions
      end
      
      def valid_email?(email)
        email_pattern = begin
          qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
          dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
          atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' + '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
          quoted_pair = '\\x5c[\\x00-\\x7f]'
          domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
          quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
          domain_ref = atom
          sub_domain = "(?:#{domain_ref}|#{domain_literal})"
          word = "(?:#{atom}|#{quoted_string})"
          domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
          local_part = "#{word}(?:\\x2e#{word})*"
          addr_spec = "#{local_part}\\x40#{domain}"
          pattern = /\A#{addr_spec}\z/
        end
        #email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
        email.match(Regexp.compile(email_pattern))
      end
      
    end
    
  end
end