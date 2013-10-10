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
      hash.each_pair do |attribute, value|
        unless value.nil?
          if value === true
            a.push "#{snake_case(attribute.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}"
          else
            if attribute == :class && value.class == Array
              a.push "#{snake_case(attribute.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}=\"#{value.join(' ')}\""
            else
              a.push "#{snake_case(attribute.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}=\"#{value}\""
            end
          end
        end
      end
      a.join(' ')
    end

  end
end