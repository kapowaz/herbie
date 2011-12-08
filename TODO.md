TODOS
=====

* Ensure all passed content is escaped
* Fix erb block-accepting tests somehow
* Magic indentation-fixing
* Implement content_for helper:

  Within a view:

  <%= content_for :scripts do %>
    <%= script 'application.js' %>
  <% end %>
  
  Within a layout:
  
  <%= content_for :scripts %>