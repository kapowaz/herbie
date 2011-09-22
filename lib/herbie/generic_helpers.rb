module Herbie
  module Helpers
    
    def snake_case(string)
      return string.downcase if string =~ /^[A-Z]+$/
      string.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
      return $+.downcase
    end

    def attributes(hash)
      a = []
      hash.each_pair do |k,v|
        a.push "#{snake_case(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}=\"#{v}\""
      end
      a.join(' ')
    end 

  end
end