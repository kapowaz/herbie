module Herbie
  module Helpers
    def tag(name, attrs={}, &block)
      if block_given?
        erb_concat "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{capture_erb(&block)}</#{name}>"
      elsif !attrs[:content].nil?
        content = attrs.delete :content
        "<#{name}#{' ' + attributes(attrs) unless attrs.empty?}>#{content}</#{name}>"
      else
        "<#{name}#{' ' + attributes(attrs) unless attrs.empty?}>"
      end
    end
    
    # work in progress
    def tags(name, collection, attrs={}, &block)
      cycle = attrs.delete :cycle
      result = ""
      collection.each_with_index do |item, i|
        a = attrs.dup
        
        unless cycle.nil?
          c = a.delete :class
          classes = []
          classes << c unless c.nil?
          classes << cycle[:even] if i.even? && cycle.key?(:even)
          classes << cycle[:odd] if i.odd? && cycle.key?(:odd)
          a[:class] = classes.join " " unless classes.empty?
        end
        
        result += tag name, a do
          block.call(item)
        end
        result += "\n"
      end
      result
    end
  
    def script(source=nil, &block)
      attrs = {
        :type    => "text/javascript",
        :charset => "utf-8"
      }
      
      if block_given?
        erb_concat "#{tag :script, attrs}\n#{capture_erb(&block)}\n</script>"
      else
        source = "/javascripts/#{source}" unless source.nil? || source.match(/^\//) || source.match(/^http/)
        attrs = attrs.merge({:src => source})
        "#{tag :script, attrs}</script>"
      end
    end
    
    def style(href=nil, attrs={}, &block)
      default_attrs = {
        :rel  => "stylesheet",
        :type => "text/css"
      }
      
      if block_given?
        default_attrs.delete :rel
        erb_concat "#{tag :style, default_attrs.merge(attrs)}\n#{capture_erb(&block)}\n</style>"
      else
        href = "/stylesheets/#{href}" unless href.match(/^\//)
        attrs = default_attrs.merge({:href => href}.merge(attrs))
        "#{tag :link, attrs}"        
      end
    end
    
    def link_to(href, text=nil, attrs={}, &block)
      attrs = {:href => href}.merge(attrs)
      if block_given?
        erb_concat "#{tag :a, attrs}#{capture_erb(&block)}</a>"
      else
        "#{tag :a, attrs}#{text ||= attrs[:href]}</a>"
      end
    end
    
  end
end