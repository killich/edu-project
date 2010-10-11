class Admins::PagesController < ApplicationController
  layout 'haml_scaffold_layout'

  before_filter :login_required
  
  # GET /pages
  def index
    @pages = Page.paginate(:all,
                           :order=>"created_at ASC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>10
                           )
                           
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /pages/1
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /pages/new
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'page успешно создано.'
        
        # Если установлено значение родителя
        if params[:page][:parent_id] && !params[:page][:parent_id].blank?
          # Сделать дочерним элементом, указанного элемента, если это возможно
          # Нужно проверять - возможно ли перемещение в этот узел
          # Если не возможно - обнулять индексы дерева и перемещать
          @page.move_to_child_of(params[:page][:parent_id])
          flash[:notice] += '<br /> Успешно установлен родитель.'
        end

        format.html { redirect_to(admins_page_path(@page)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /pages/1
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'page успешно обновлено.'
        
        # Если установлено значение родителя
        if params[:page][:parent_id] && !params[:page][:parent_id].blank?
          # Сделать дочерним элементом, указанного элемента, если это возможно
          # Нужно проверять - возможно ли перемещение в этот узел
          # Если не возможно - обнулять индексы дерева и перемещать
          @page.move_to_child_of(params[:page][:parent_id])
          flash[:notice] += '<br /> Успешно установлен родитель.'
        end
        
        format.html { redirect_to(admins_page_path(@page)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /pages/1
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(admins_pages_url) }
    end
  end
end