# encoding: utf-8
require_relative "../lib/herbie.rb"

describe Herbie::Helpers do
  include Herbie::Helpers
  
  it "should be able to output a simple tag" do
    img = {
      :src    => "/path/to/image.jpg",
      :height => 320,
      :width  => 640,
      :alt    => "An image of something"
    }
    
    tag(:img, img).should == "<img src=\"#{img[:src]}\" height=\"#{img[:height]}\" width=\"#{img[:width]}\" alt=\"#{img[:alt]}\">"
  end
  
  describe "script helpers" do
    it "should prefix the path to the script with ‘/javascripts’ if the script path is relative" do
      script("script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/javascripts/script.js\"></script>"
    end
    
    it "should output a script with an absolute path to the script if the path provided was absolute" do
      script("/path/to/script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/path/to/script.js\"></script>"
    end

    # capturing erb as part of an rspec test...?
    # it "should output a script tag with inline javascript if a block was passed" do
    #   hello_world = "function hello_world(){ document.write('hello world!'); }"
    #   script do
    #     erb_concat hello_world
    #   end.should == "<script type=\"text/javascript\" charset=\"utf-8\">\n#{hello_world}\n</script>"
    # end
  end
  
  describe "stylesheet helpers" do
    it "should prefix the path to the script with ‘/stylesheets’ if the stylesheet path is relative" do
      style("foo.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/stylesheets/foo.css\">"
    end
    
    it "should output a link element with the absolute path to the stylesheet if the path provided was absolute" do
      style("/style/foo.css").should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/style/foo.css\">"
    end
    
    it "should output a link element with appropriate media query attribute if provided" do
      media = "screen and (min-width:500px)"
      style("/style/foo.css", :media => media).should == "<link rel=\"stylesheet\" type=\"text/css\" href=\"/style/foo.css\" media=\"#{media}\">"
    end
    
    # TODO: output a style block as <style type="text/css"> /* arbitrary CSS */ </script>
  end
  
  describe "link helpers" do
    it "should be able to output a simple link" do
      href = "http://www.foo.com/"
      link(href).should == "<a href=\"#{href}\">#{href}</a>"
    end
    
    it "should be able to output a link with href and text" do
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      link(href, text).should == "<a href=\"#{href}\">#{text}</a>"
    end
    
    it "should be able to output links with arbitrary attributes" do
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      attrs = {
        :class => "navigation",
        :target => "_parent"
      }
      link(href, text, attrs).should == "<a href=\"#{href}\" class=\"navigation\" target=\"_parent\">#{text}</a>"
    end
    
    # TODO: test for links that accept blocks (e.g. <a href="#"><img src="foo.png"></a>)
  end
  
  describe "partial helper" do
    # TODO: test this? currently relies on a method from Sinatra
  end
end