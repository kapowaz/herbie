module Herbie
  module Helpers
    private
    def snake_case(string)
      return string.downcase if string =~ /^[A-Z]+$/
      string.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
      return $+.downcase
    end

    def attributes(hash)
      a = []
      hash.each_pair do |k,v|
        unless v.nil?
          if v === true
            a.push "#{snake_case(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}"
          else
            a.push "#{snake_case(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}=\"#{v}\""
          end
        end
      end
      a.join(' ')
    end 

  end
end