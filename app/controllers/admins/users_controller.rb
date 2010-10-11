class Admins::UsersController < ApplicationController
  before_filter :login_required
  
  # GET /users
  def index
    @users = User.paginate(:all,
                           :order=>"created_at ASC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>20
                           )
                           
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.haml
    end
  end
  
  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def create
    #cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    
    # Создать пользователя
    # Назначить роль зарегистрированного пользователя
    # Сохранить
    @user = User.new(params[:user])
    @user.set_role(Role.find_by_name('site_administrator'))
    @user.save
        
    if @user.errors.empty?
      # Если все успешно - создадим пользователю пустой профайл
      Profile.new(:user_id=>@user.id).save
      
      # Если все успешно - создадим пользователю набор базовых страниц
      # @user.pages.new(:title=>'Главная').save
      
      # Если все успешно - создадим пользователю Разделы файлового хранилища
      @user.storage_sections.new(:title=>'Изображения').save!
      @user.storage_sections.new(:title=>'Текстовые документы').save!
      @user.storage_sections.new(:title=>'Электронные таблицы').save!
      @user.storage_sections.new(:title=>'Презентации').save!
      @user.storage_sections.new(:title=>'Другие файлы').save!
      
      #self.current_user = @user
      redirect_to(admins_users_path)
      flash[:notice] = t('user.auth.created')
    else
      #flash[:warning] = t('server.error')
      flash[:notice] = t('user.auth.cant_be_create')
      render :template => "admins/users/new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'user успешно обновлено.'
        format.html { redirect_to(edit_admins_user_path(@user)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admins_users_url) }
    end
  end
  
  def change_role
    @user = User.find(params[:id])
    @user.role_id= params[:user][:role_id]
    @user.save!
    redirect_back_or ('/')
  end
  
end