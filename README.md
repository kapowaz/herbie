Herbie
======

Lovable HTML view helpers for use with ERB. A lightweight set of helpers ideal for micro-frameworks like [Sinatra](http://www.sinatrarb.com/).

Example installation in a Sinatra application
---------------------------------------------

* Add `gem "herbie"` to your Gemfile
* `$ bundle install`
* Add `require 'herbie'` to myapp.rb
* Add Herbie to your available helpers by adding `helpers Herbie::Helpers` to myapp.rb

Usage
-----

Examples:

Create an arbitrary HTML element using a symbol for the type, and a hash of attributes:

    <%= tag :input, {:type => "text", :name => "message", :value => "hello world"} %> # => <input type="text" name="message" value="hello world">
    
Create a JavaScript include element:
    
    <%= script '/path/to/script.js' %> # => <script type="text/javascript" charset="utf-8" src="/path/to/script.js"></script>

Create a stylesheet include:

    <%= style '/path/to/stylesheet.css %> # => <link rel="stylesheet" type="text/css" href="/path/to/stylesheet.css">

Create a hyperlink:

    <%= link_to 'http://www.foo.com/', 'Foo' %> # => <a href="http://www.foo.com/">Foo</a>
    
Create an element which encloses some arbitrary markup:

    <% tag :div, {:class => "content"} do %>
      <h1>Heading</h1>
      <p>Hello there!</p>
    <% end %>
    
    # =>
    
    <div class="content">
      <h1>Heading</h1>
      <p>Hello there!</p>
    </div>
    
Create an inline JavaScript element:

    <% script do %>
      function hello_world(){
        console.log('Hello World!');
      }
    <% end %>
  
    # => 
  
    <script type="text/javascript" charset="utf-8">
      function hello_world(){
        console.log('Hello World!');
      }
    </script>

Create an inline style element:

    <% style :media => "screen and (min-width:500px)" do %>
      body { margin:0; padding:0; }
    <% end %>
    
    # =>
    
    <style type="text/css" media="screen and (min-width:500px)">
      body { margin:0; padding:0; }
    </style>
    
Create an unordered list of links from an appropriate hash (N.B. this doesn't actually work yet — see TODOS):

    <%
    navigation_items = [
      {:text => "Home", :href => "/", :title => "Back to the homepage"},
      {:text => "Shop", :href => "/shop", :title => "View all our products"},
      {:text => "Orders", :href => "/orders", :title => "View your existing orders"},
      {:text => "Contact Us", :href => "/contactus", :title => "Get in touch with us"},
      {:text => "Help", :href => "/help", :title => "Can't find what you need? Get help here"}
    ]
    
    tag :ul, :class => "navigation" do
      navigation_items.each do |item|
        tag :li do
          link_to item[:href], item[:text], {:title => item[:title]}
        end
      end
    end %>
    
    # =>
    
    <ul class="navigation">
      <li><a href="/" title="Back to the homepage">Home</a></li>
      <li><a href="/shop" title="View all our products">Shop</a></li>
      <li><a href="/orders" title="View your existing orders">Orders</a></li>
      <li><a href="/contactus" title="Get in touch with us">Contact Us</a></li>
      <li><a href="/help" title="Can't find what you need? Get help here">Help</a></li>
    </ul>
