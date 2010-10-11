<%
  scope ||= ''
  path_scope= scope.blank? ? '' : "#{scope}_"
%>
.body
  %h1
    Объект
    = "<%= model.capitalize %>"
    = "#"+@<%= model %>.id.to_s
    
  -if flash[:notice]
    .notice
      = flash[:notice]

  -if flash[:error]
    .error
      = flash[:error]

  %table
    %tr
      %td
        %table.object_card
        <%struct.each do |elem|%>
        <%elem.each do |field_name, param|%>
          <% unless param[:secondary_hide] %>
          %tr
            %td.field
              <%= param[:title] %>
            %td
            <%
              case param[:type]
              when 'text'
            %>
              .readeble_text_field
                =(h @<%= "#{model}.#{field_name}" %>).gsub("\n", "<br />")
            <% else %>
              =h @<%= "#{model}.#{field_name}" %>
            <%end #case param[:type]%>
          <%end # param[:secondary_hide]%>
        <%end #elem.each do |field_name, param|%>
       <%end #struct.each do |elem| %>

          %tr
            %td.field
              Управление
            %td
              = link_to 'Редактировать', edit_<%=path_scope%><%= model %>_path(@<%= model %>)
              = link_to 'Полный список', <%=path_scope%><%= model.pluralize %>_path