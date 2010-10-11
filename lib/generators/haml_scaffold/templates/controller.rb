<%
  scope ||= ''
  controller_scope = scope.blank? ? '' : "#{scope.capitalize}::"  
  path_scope= scope.blank? ? '' : "#{scope}_"
%>

class <%= controller_scope %><%= model.pluralize.camelize %>Controller < ApplicationController
  layout 'haml_scaffold_layout'
  
  # GET /<%= model.pluralize %>
  def index
    @<%= model.pluralize %> = <%= model.camelize %>.paginate(:all,
                           :order=>"created_at ASC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>10
                           )
                           
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /<%= model.pluralize %>/1
  def show
    @<%= model %> = <%= model.camelize %>.find(params[:id])

    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /<%= model.pluralize %>/new
  def new
    @<%= model %> = <%= model.camelize %>.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /<%= model.pluralize %>/1/edit
  def edit
    @<%= model %> = <%= model.camelize %>.find(params[:id])
  end

  # POST /<%= model.pluralize %>
  def create
    @<%= model %> = <%= model.camelize %>.new(params[:<%= model %>])

    respond_to do |format|
      if @<%= model %>.save
        flash[:notice] = '<%= model %> успешно создано.'
        format.html { redirect_to(<%= path_scope %><%= model %>_path(@<%= model %>)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /<%= model.pluralize %>/1
  def update
    @<%= model %> = <%= model.camelize %>.find(params[:id])

    respond_to do |format|
      if @<%= model %>.update_attributes(params[:<%= model %>])
        flash[:notice] = '<%= model %> успешно обновлено.'
        format.html { redirect_to(<%= path_scope %><%= model %>_path(@<%= model %>)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /<%= model.pluralize %>/1
  def destroy
    @<%= model %> = <%= model.camelize %>.find(params[:id])
    @<%= model %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= path_scope %><%= model.pluralize %>_url) }
    end
  end
end