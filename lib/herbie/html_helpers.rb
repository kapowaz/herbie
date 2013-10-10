module Herbie
  module Helpers
    def tag(name, attrs={}, &block)
      if block_given?
        erb_concat "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty? || attributes(attrs).empty?}>\n#{capture_erb(&block)}\n</#{name}>\n"
      elsif !attrs[:content].nil?
        case name
        when :meta
          "<#{name}#{' ' + attributes(attrs) unless attrs.empty? || attributes(attrs).empty?}>"
        else
          content = attrs.delete :content
          "<#{name}#{' ' + attributes(attrs) unless attrs.empty? || attributes(attrs).empty?}>#{content}</#{name}>"
        end
      else
        case name
        when :select          
          option_tags = attrs.delete(:options).collect do |option|
            if option.key? :label
              option[:content] = option.delete(:options).collect {|o| tag :option, o}.join
              tag :optgroup, option
            else
              tag :option, option
            end
          end.join
          "<#{name}#{' ' + attributes(attrs) unless attrs.empty? || attributes(attrs).empty?}>#{option_tags}</#{name}>"
        when :span
          "<#{name}#{' ' + attributes(attrs) unless attrs.empty? || attributes(attrs).empty?}></#{name}>"
        else
          "<#{name}#{' ' + attributes(attrs) unless attrs.empty? || attributes(attrs).empty?}>"
        end
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

    def script(source=nil, options={}, &block)
      attrs = {
        :type    => "text/javascript",
        :charset => "utf-8"
      }

      if block_given?
        erb_concat "#{tag :script, attrs}\n#{capture_erb(&block)}\n</script>\n"
      else
        source = "/javascripts/#{source}" unless source.nil? || source.match(/^\/{1,2}|^http:\/\/|^https:\/\//)
        source = source.sub(/.js$/, '.min.js') if source && options[:minified] && !source.match(/.min.js$/)
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
        erb_concat "#{tag :style, default_attrs.merge(attrs)}\n#{capture_erb(&block)}\n</style>\n"
      else
        href = "/stylesheets/#{href}" unless href.match(/^\/{1,2}|^http:\/\/|^https:\/\//)
        
        if attrs[:minified]
          attrs.delete :minified
          href = href.sub(/.css$/, '.min.css') if href && !href.match(/.min.css$/)
        end
        
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

    def content_for(name, content=nil, &block)
      @captured_content ||= {}

      if content || block_given?
        if @captured_content.key? name
          @capured_content[name] += content || capture_erb(&block)
        else
          @capured_content[name] = content || capture_erb(&block)
        end
      else
        @captured_content[name]
      end
    end

  end
end