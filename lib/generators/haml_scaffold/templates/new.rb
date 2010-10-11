<%
  scope ||= ''
  path_scope= scope.blank? ? '' : "#{scope}_"
  form_addon = scope.blank? ? '' : ", :url => #{path_scope}#{model.pluralize}_path"
%>
.body
  %h1
    Новый объект <%= model.capitalize %>

  %table
    %tr
      %td
        -form_for(@<%= model %><%= form_addon %>) do |f|
          = f.error_messages
          %table.object_card
            <%struct.each do |elem|%>
            <%elem.each do |field_name, param|%>
            <% unless param[:secondary_hide] %>
            %tr
              %td.field
                <%= param[:title] %>
              %td
                <% if param[:edit]==false %>
                = h @<%= "#{model}.#{field_name}" %>
                <%else%>
                  <%
                    case param[:type]
                    when 'text'
                  %>
                .editable_text_field
                  %span
                    = f.text_area :<%= field_name %>, :class=>:scaffold_textarea
                  <% else %>
                %span
                  = f.text_field :<%= field_name %>, :class=>:scaffold_field
                  <%end #case param[:type]%>
                <%end # param[:edit]==false%>
                <%end # param[:secondary_hide]==false%>
            <%end #elem.each do |field_name, param|%>
           <%end #struct.each do |elem| %>

            %tr
              %td.field
                Управление
              %td
                = f.submit "Создать"
                = link_to 'Полный список', <%=path_scope%><%= model.pluralize %>_path