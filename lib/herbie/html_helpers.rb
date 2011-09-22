module Herbie
  module Helpers
    
    def tag(name, attrs = {}, &block)
      if block_given?
        erb_concat "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{capture_erb(&block)}</#{name}>"
      elsif !attrs[:content].nil?
        content = attrs.delete :content
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{content}</#{name}>"
      else
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>"
      end
    end
  
    def script(source=nil, &block)
      attrs = {
        :type    => "text/javascript",
        :charset => "utf-8"
      }
      
      if block_given?
        erb_concat "#{tag :script, attrs}\n#{capture_erb(&block)}\n</script>"
      else
        source = "/javascripts/#{source}" unless source.nil? || source.match(/^\//)
        attrs = attrs.merge({:src => source})
        "#{tag :script, attrs}</script>"
      end
    end
    
    def style(href=nil, attrs={}, &block)
      default_attrs = {
        :rel  => "stylesheet",
        :type => "text/css"
      }
      href = "/stylesheets/#{href}" unless href.match(/^\//)
      attrs = default_attrs.merge({:href => href}.merge(attrs))
      "#{tag :link, attrs}"
    end
  
    def link(href, text=nil, attrs={}, &block)
      attrs = {:href => href}.merge(attrs)
      if block_given?
        erb_concat "#{tag :a, attrs}#{capture_erb(&block)}</a>"
      else
        "#{tag :a, attrs}#{text ||= attrs[:href]}</a>"
      end
    end

    # N.B. This actually relies on Sinatra's erb method, so should probably belong elsewhere (or this gem depend on sinatra?)
    def partial(template, options={})
      erb "partials/_#{template}".to_sym, options.merge(:layout => false)
    end
    
  end
end