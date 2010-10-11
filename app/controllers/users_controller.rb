require 'digest/sha1'
class UsersController < ApplicationController
  # Формирование данных для отображения базового меню-навигации
  # Проверка на регистрацию
  before_filter :navigation_menu_init
  before_filter :login_required, :except=>[:index, :new, :create]
  #before_filter :access_to_controller_action_required, :only=>[:cabinet]
  
  # Список пользователей системы
  def index
    @users = User.paginate(:all,
                           :order=>"id ASC", #ASC, DESC
                           :include=>:role,
                           :page => params[:page],
                           :per_page=>20
                           )
  end
  
  # кабинет пользователя
  def cabinet
  end
  
  # Анкета пользователя
  def profile
    @profile= current_user.profile
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    
    # Создать пользователя
    # Назначить роль зарегистрированного пользователя
    # Сохранить
    @user = User.new(params[:user])
    @user.set_role(Role.find_by_name('registrated_user'))
    @user.save
        
    if @user.errors.empty?
      # Если все успешно - создадим пользователю пустой профайл
      Profile.new(:user_id=>@user.id).save
      
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = t('user.auth.entered')
    else
      flash[:notice] = t('user.auth.cant_be_create')
      flash[:warning] = t('server.error')
      render :action => 'new'
    end
  end
  
  def base_header
    @user= User.find_by_zip(params[:id])
    # Если нет данных о пользователе или Аватаре
    if !params[:user] || !params[:user][:base_header]
      flash[:notice]= 'Изображение не установлено'
      redirect_to(cabinet_users_url(:subdomain=>current_user.subdomain)) and return
    end
    
    @user.base_header= params[:user][:base_header]
    extension = File.extname(@user.base_header_file_name)
    @user.base_header.instance_write(:file_name, "#{Digest::SHA1.hexdigest(@user.login+Time.now.to_s)}#{extension}") 
    
    respond_to do |format|
      if @user.save
        flash[:notice]= 'Шапка сайта успешно обновлена'
        redirect_to(cabinet_users_url(:subdomain=>current_user.subdomain)) and return
      else
        flash[:error]= 'Изображение не удалось загрузить'
        format.html { render  :action => :cabinet }
      end
    end
  end
  
  protected

  def access_to_controller_action_required
    access_denied if current_user.has_complex_block?(:administrator, controller_name)
    return true   if current_user.has_complex_access?(:administrator, controller_name)
    return true   if current_user.has_role_policy?(:administrator, controller_name)
    access_denied if current_user.has_complex_block?(controller_name, action_name)
    return true   if current_user.has_complex_access?(controller_name, action_name) && current_user.is_owner_of?(@user)
    return true   if current_user.has_role_policy?(controller_name, action_name)    && current_user.is_owner_of?(@user)
    access_denied
  end
  
end
