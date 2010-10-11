<%
  scope ||= ''
  path_scope= scope.blank? ? '' : "#{scope}_"
%>
.body
  -if flash[:notice]
    .notice
      = flash[:notice]

  -if flash[:error]
    .error
      = flash[:error]

  %h1
    Список объектов <%= model.pluralize.capitalize%> 
    = link_to "Весь список", <%=path_scope%><%= model.pluralize %>_path

  %br
  = link_to 'Новый объект <%= model.capitalize %>', new_<%=path_scope%><%= model %>_path
  %br
  %br
  = will_paginate @<%= model.pluralize %>, :class=>:scaffold_pagination, :previous_label=>"&larr;", :next_label=>"&rarr;"

<% if display_block %>
  %table
    %tr
      -for <%= model %> in @<%= model.pluralize %>
        %td
          %table.object_card
            %tr
              %td.field
                Управление
              %td
                = link_to 'Показать', <%=path_scope%><%= model %>_path(<%= model %>)
                = link_to 'Редактировать', edit_<%=path_scope%><%= model %>_path(<%= model %>)
                = link_to 'Удалить', <%=path_scope%><%= model %>_path(<%= model %>), :confirm => 'Вы уверены?', :method => :delete

            <%struct.each do |elem|%>
            %tr
              <%elem.each do |field_name, param|%>
              %td.field
                <%= param[:title] %>
              %td
                <%
                  case param[:type]
                  when 'text'
                %>
                .text_field
                  =(h truncate(<%= "#{model}.#{field_name}" %>.chars, 250, "")).gsub("\n", "<br />")
                  &hellip;
                <% else %>
                =h <%= "#{model}.#{field_name}" %>
                <%end #case param[:type]%>
            <%end #elem.each do |field_name, param|%>
           <%end #struct.each do |elem| %>
           
            %tr
              %td.field
                Управление
              %td
                = link_to 'Показать', <%=path_scope%><%= model %>_path(<%= model %>)
                = link_to 'Редактировать', edit_<%=path_scope%><%= model %>_path(<%= model %>)
                = link_to 'Удалить', <%=path_scope%><%= model %>_path(<%= model %>), :confirm => 'Вы уверены?', :method => :delete
<% else %>
  %table
    %tr
    <%struct.each do |elem|%>
      %td
      <%elem.each do |field_name, param|%>
        <%= param[:title] %>
      <%end #elem.each do |field_name, param|%>
    <%end #struct.each do |elem| %>
    

      %td
        Управление
        
    -for <%= model %> in @<%= model.pluralize %>
      %tr
      <%struct.each do |elem|%>
        %td
        <%elem.each do |field_name, param|%>
          =h <%= "#{model}.#{field_name}" %>  
        <%end #elem.each do |field_name, param|%>
      <%end #struct.each do |elem| %>

        %td
          %div{:style=>"height:25px;"}
            = link_to 'Показать', <%=path_scope%><%= model %>_path(<%= model %>)
          %div{:style=>"height:25px;"}
            = link_to 'Редактировать', edit_<%=path_scope%><%= model %>_path(<%= model %>)
          %div{:style=>"height:25px;"}
            = link_to 'Удалить', <%=path_scope%><%= model %>_path(<%= model %>), :confirm => 'Вы уверены?', :method => :delete

<% end %>

  %br
  = will_paginate @<%= model.pluralize %>, :class=>:scaffold_pagination, :previous_label=>"&larr;", :next_label=>"&rarr;"