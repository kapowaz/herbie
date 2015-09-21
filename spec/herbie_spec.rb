# encoding: utf-8
require_relative "../lib/herbie.rb"
require "rspec/expectations"

describe Herbie::Helpers do
  include Herbie::Helpers

  describe "tag helpers" do
    it "should be able to output a simple tag" do
      attrs = {
        :src    => "/path/to/image.jpg",
        :height => 320,
        :width  => 640,
        :alt    => "An image of something"
      }

      tag(:img, attrs).should == "<img src=\"#{attrs[:src]}\" height=\"#{attrs[:height]}\" width=\"#{attrs[:width]}\" alt=\"#{attrs[:alt]}\">"
    end

    it "should not output attributes whose values are nil" do
      attrs = {
        :type    => "checkbox",
        :name    => "stay_logged_in",
        :value   => "true",
        :checked => nil
      }

      tag(:input, attrs).should == "<input type=\"#{attrs[:type]}\" name=\"#{attrs[:name]}\" value=\"#{attrs[:value]}\">"
    end

    it "should output just the property name for attributes with a boolean value of true" do
      attrs = {
        :type    => "checkbox",
        :name    => "stay_logged_in",
        :value   => "true",
        :checked => true
      }

      tag(:input, attrs).should == "<input type=\"#{attrs[:type]}\" name=\"#{attrs[:name]}\" value=\"#{attrs[:value]}\" checked>"
    end

    it "should output the content parameter as an attribute on meta tags" do
      attrs = {
        :name    => "viewport",
        :content => "width=device-width, user-scalable=yes, initial-scale=1.0"
      }

      tag(:meta, attrs).should == "<meta name=\"#{attrs[:name]}\" content=\"#{attrs[:content]}\">"
    end

    it "should ignore passed attributes with a nil value" do
      tag(:div, :class => nil, :content => "They have absolutely no class, and they're always on the hustle.").should == "<div>They have absolutely no class, and they're always on the hustle.</div>"
    end

    it "should output all class names supplied as an array" do
      tag(:div, :class => [:foo, :bar], :content => "hello world").should == "<div class=\"foo bar\">hello world</div>"
    end

    it "should automatically close span tags when no content is supplied" do
      tag(:span).should == "<span></span>"
    end

    it "should output a new line after passing a block to a tag" do
      pending "Need a mechanism for capturing erb output within a passed block"
      output = tag :div do
        "hello world"
      end

      output.should end_with "\n"
    end

    it "should output select tags with a supplied list of options" do
      attrs = {
        :name => "colour",
        :options => [
          {:content => "White",  :value => :common},
          {:content => "Green",  :value => :uncommon},
          {:content => "Blue",   :value => :rare},
          {:content => "Purple", :value => :epic},
          {:content => "Orange", :value => :legendary}
        ]
      }

      tag(:select, attrs).should == "<select name=\"colour\"><option value=\"common\">White</option><option value=\"uncommon\">Green</option><option value=\"rare\">Blue</option><option value=\"epic\">Purple</option><option value=\"legendary\">Orange</option></select>"
    end

    it "should output select tags with a supplied list of optgroups" do
      attrs = {
        :name => "vehicles",
        :options => [
          {
            :label => "Cars",
            :options => [
              {:content => "Ferrari", :value => :ferrari},
              {:content => "Volkswagen", :value => :vw},
              {:content => "Ford", :value => :ford}
            ]
          },
          {
            :label => "Trucks",
            :options => [
              {:content => "Volvo", :value => :volvo},
              {:content => "Toyota", :value => :toyota},
              {:content => "General Motors", :value => :gm}
            ]
          },
          {
            :label => "Bikes",
            :options => [
              {:content => "Suzuki", :value => :suzuki},
              {:content => "Ducati", :value => :ducati},
              {:content => "Kawasaki", :value => :kawasaki}
            ]
          }
        ]
      }

      tag(:select, attrs).should == "<select name=\"vehicles\"><optgroup label=\"Cars\"><option value=\"ferrari\">Ferrari</option><option value=\"vw\">Volkswagen</option><option value=\"ford\">Ford</option></optgroup><optgroup label=\"Trucks\"><option value=\"volvo\">Volvo</option><option value=\"toyota\">Toyota</option><option value=\"gm\">General Motors</option></optgroup><optgroup label=\"Bikes\"><option value=\"suzuki\">Suzuki</option><option value=\"ducati\">Ducati</option><option value=\"kawasaki\">Kawasaki</option></optgroup></select>"
    end

    it "should output select tags with a mixed list of optgroups and options" do
      attrs = {
        :name => "vehicles",
        :options => [
          {:content => "— Choose —"},
          {
            :label => "Cars",
            :options => [
              {:content => "Ferrari", :value => :ferrari},
              {:content => "Volkswagen", :value => :vw},
              {:content => "Ford", :value => :ford}
            ]
          },
          {
            :label => "Trucks",
            :options => [
              {:content => "Volvo", :value => :volvo},
              {:content => "Toyota", :value => :toyota},
              {:content => "General Motors", :value => :gm}
            ]
          },
          {
            :label => "Bikes",
            :options => [
              {:content => "Suzuki", :value => :suzuki},
              {:content => "Ducati", :value => :ducati},
              {:content => "Kawasaki", :value => :kawasaki}
            ]
          }
        ]
      }

      tag(:select, attrs).should == "<select name=\"vehicles\"><option>— Choose —</option><optgroup label=\"Cars\"><option value=\"ferrari\">Ferrari</option><option value=\"vw\">Volkswagen</option><option value=\"ford\">Ford</option></optgroup><optgroup label=\"Trucks\"><option value=\"volvo\">Volvo</option><option value=\"toyota\">Toyota</option><option value=\"gm\">General Motors</option></optgroup><optgroup label=\"Bikes\"><option value=\"suzuki\">Suzuki</option><option value=\"ducati\">Ducati</option><option value=\"kawasaki\">Kawasaki</option></optgroup></select>"
    end

    it "should output closing textarea tag when supplied with empty content" do
      attrs = {
        id:          'comment',
        placeholder: 'Any comments?'
      }
      tag(:textarea, attrs).should == "<textarea id=\"comment\" placeholder=\"Any comments?\"></textarea>"
    end

    it "should output tags mixed with ERB" do
      pending "Need a mechanism for capturing erb output within a passed block"
      erb_fragment = <<-ERB
<% tag :div, :class => "container" do %>
Hello world!
<% end %>
ERB

      html_fragment = <<-HTML
<div class="container">
Hello world!
</div>
HTML

      template = Tilt['erb'].new { erb_fragment }
      template.render.should == html_fragment
    end

    it "should output all nested tag method calls" do
      pending "Need a mechanism for capturing erb output within a passed block"
      markup = "<div class=\"container\">\n<h1>Status Report</h1>\n</div>"
      result = tag :div, :class => "container" do
        tag :h1, :content => "Status Report"
      end
      result.should == markup
    end

    it "should output a collection of tags" do
      pending "Need a mechanism for capturing erb output within a passed block"
      markup = <<-MARKUP
<li><a href="/" title="Back to the homepage">Home</a></li>
<li><a href="/shop" title="View all our products">Shop</a></li>
<li><a href="/orders" title="View your existing orders">Orders</a></li>
<li><a href="/contactus" title="Get in touch with us">Contact Us</a></li>
<li><a href="/help" title="Can't find what you need? Get help here">Help</a></li>
MARKUP

      navigation_items = [
        {:text => "Home", :href => "/", :title => "Back to the homepage"},
        {:text => "Shop", :href => "/shop", :title => "View all our products"},
        {:text => "Orders", :href => "/orders", :title => "View your existing orders"},
        {:text => "Contact Us", :href => "/contactus", :title => "Get in touch with us"},
        {:text => "Help", :href => "/help", :title => "Can't find what you need? Get help here"}
      ]
      result = tags :li, navigation_items do |item|
        link_to item[:href], item[:text], :title => item[:title]
      end
      result.should == markup
    end

    it "should allow an arbitrary class to be added to alternating elements within the collection" do
      pending "Need a mechanism for capturing erb output within a passed block"
      markup = <<-MARKUP
<li class="even">Annie</li>
<li>Brenda</li>
<li class="even">Charlie</li>
<li>Davinia</li>
<li class="even">Emma</li>
MARKUP

      names = ['Annie', 'Brenda', 'Charlie', 'Davinia', 'Emma']
      result = tags :li, names, :cycle => {:even => "even"} do |name|
        name
      end
      result.should == markup
    end
  end

  describe "script helpers" do
    it "should prefix the path to the script with ‘/javascripts’ if the script path is relative" do
      script("script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/javascripts/script.js\"></script>"
    end

    it "should output a script with an absolute path to the script if the path provided was absolute" do
      script("/path/to/script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/path/to/script.js\"></script>"
    end

    it "should output a script with an absolute path to the script if the path provided begins with http://, https:// or //" do
      script("http://code.jquery.com/jquery.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://code.jquery.com/jquery.js\"></script>" and
      script("https://code.jquery.com/jquery.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"https://code.jquery.com/jquery.js\"></script>" and
      script("//code.jquery.com/jquery.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"//code.jquery.com/jquery.js\"></script>"
    end

    it "should output a modified URL with .min.js as the file extension when the minified option is true" do
      script("/path/to/script.js", :minified => true).should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/path/to/script.min.js\"></script>"
    end

    it "should output a script element with arbitrary javascript content provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      script_block = Proc.new { "function hello_world(){ console.log(\"hello world!\"); }" }
      script(&script_block).should == "<script type=\"text/javascript\" charset=\"utf-8\">\n#{capture_erb(&script_block)}\n</script>"
    end

    it "should output a jQuery script include with the specified options" do
      pending "NYI"

      jquery(:version => "1.5.0", :min => false, :cdn => :google).should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"\"></script>"
    end
  end

  describe "stylesheet helpers" do
    it "should prefix the path to the script with ‘/stylesheets’ if the stylesheet path is relative" do
      style("foo.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/stylesheets/foo.css\">"
    end

    it "should output a link element with the absolute path to the stylesheet if the path provided was absolute" do
      style("/style/foo.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/style/foo.css\">"
    end

    it "should output a link element with the absolute path to the stylesheet if the path provided starts with http://, https:// or //" do
      style("http://foo.com/style/bar.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://foo.com/style/bar.css\">" and
      style("https://foo.com/style/bar.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://foo.com/style/bar.css\">" and
      style("//foo.com/style/bar.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"//foo.com/style/bar.css\">"
    end

    it "should output a link element with appropriate media query attribute if provided" do
      media = "screen and (min-width:500px)"
      style("/style/foo.css", :media => media).should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/style/foo.css\" media=\"#{media}\">"
    end

    it "should output a modified URL with .min.css as the file extension when the minified option is true" do
      style("/style/foo.css", :minified => true).should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/style/foo.min.css\">"
    end

    it "should output a style element with arbitrary content provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      media     = "screen and (min-width:500px)"
      css_block = Proc.new { "body { font-family:'Helvetica'; }" }
      style({:media => media}, &css_block).should == "<style type=\"text/css\" media=\"#{media}\">\n#{capture_erb(&css_block)}\n</style>"
    end
  end

  describe "link helpers" do
    it "should be able to output a simple link" do
      href = "http://www.foo.com/"
      link_to(href).should == "<a href=\"#{href}\">#{href}</a>"
    end

    it "should be able to output a link with href and text" do
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      link_to(href, text).should == "<a href=\"#{href}\">#{text}</a>"
    end

    it "should be able to output links with arbitrary attributes" do
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      attrs = {
        :class => "navigation",
        :target => "_parent"
      }
      link_to(href, text, attrs).should == "<a href=\"#{href}\" class=\"#{attrs[:class]}\" target=\"#{attrs[:target]}\">#{text}</a>"
    end

    it "should be able to output a link enclosing arbitrary markup provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      attrs = {
        :class => "image"
      }
      markup_block = Proc.new { tag :img, :src => "foo.png" }
      link_to(href, text, attrs, &markup_block).should == "<a href=\"#{href}\" class=\"#{attrs[:class]}\">#{capture_erb(&markup_block)}</a>"
    end
  end
end
