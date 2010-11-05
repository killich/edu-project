class ReportsController < ApplicationController

  before_filter :find_report,                             :only=>   [:show, :edit, :update, :destroy, :up, :down]
  
  # GET /reports
  def index
    @reports = @user.reports.paginate(:all,
                                       :order=>"created_at ASC", #ASC, DESC
                                       :select=>'id, title, zip, parent_id, updated_at',
                                       :order=>"lft ASC",
                                       :page => params[:page],
                                       :per_page=>30
                                     )
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /reports/1
  def show
    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /reports/new
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  def create
    @report = @user.reports.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Новость успешно создана'
        format.html { redirect_to(edit_report_path(@report.zip)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /reports/1
  def update
    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Новость успешно обновлена'
        
        flash[:notice] = 'Новость успешно обновлена'
        format.html{redirect_back_or(news_path(:subdomain=>@subdomain))}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def up
    if @report.move_possible?(@report.left_sibling)
      @report.move_left
      flash[:notice] = 'Новость перемещена вверх'
    else
      flash[:notice] = 'Новость не может быть перемещена'
    end
    redirect_back_or(news_path(:subdomain=>@subdomain)) and return
  end
  
  def down
    if @report.move_possible?(@report.right_sibling)
      @report.move_right
      flash[:notice] = 'Новость перемещена вниз'
    else
      flash[:notice] = 'Новость не может быть перемещена'
    end
    redirect_back_or(news_path(:subdomain=>@subdomain)) and return
  end
  
  # DELETE /reports/1
  def destroy
    @report.destroy
    flash[:notice] = 'Новость успешно удалена'
    respond_to do |format|
      format.html { redirect_back_or(news_path(:subdomain=>@subdomain)) }
    end
  end
  
  protected

  def find_report
    @report= Report.find_by_zip(params[:id])
    access_denied and return unless @report
  end
end