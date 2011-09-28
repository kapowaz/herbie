# encoding: utf-8
require_relative "../lib/herbie.rb"

describe Herbie::Helpers do
  include Herbie::Helpers
  
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
  
  describe "script helpers" do
    it "should prefix the path to the script with ‘/javascripts’ if the script path is relative" do
      script("script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/javascripts/script.js\"></script>"
    end
    
    it "should output a script with an absolute path to the script if the path provided was absolute" do
      script("/path/to/script.js").should == "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/path/to/script.js\"></script>"
    end
    
    it "should output a script element with arbitrary javascript content provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      script_block = Proc.new { "function hello_world(){ console.log(\"hello world!\"); }" }
      script(&script_block).should == "<script type=\"text/javascript\" charset=\"utf-8\">\n#{capture_erb(&script_block)}\n</script>"
    end
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
    
    it "should output a style element with arbitrary content provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      media     = "screen and (min-width:500px)"
      css_block = Proc.new { "body { font-family:'Helvetica'; }" }
      style({:media => media}, &css_block).should == "<script type=\"text/css\" media=\"#{media}\">\n#{capture_erb(&css_block)}\n</script>"
    end
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
      link(href, text, attrs).should == "<a href=\"#{href}\" class=\"#{attrs[:class]}\" target=\"#{attrs[:target]}\">#{text}</a>"
    end
    
    it "should be able to output a link enclosing arbitrary markup provided by a block" do
      pending "Need a mechanism for capturing erb output within a passed block"
      href = "http://www.foo.com/"
      text = "Visit foo.com"
      attrs = {
        :class => "image"
      }
      markup_block = Proc.new { tag :img, :src => "foo.png" }
      link(href, text, attrs, &markup_block).should == "<a href=\"#{href}\" class=\"#{attrs[:class]}\">#{capture_erb(&markup_block)}</a>"
    end
  end
end