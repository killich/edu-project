class Admins::RolesController < ApplicationController

=begin
  Управление таблицей настроек
  CRUD таблицы настроек
  Настройки играют главную роль при разграничении действий между поьзователями
  и при рабте с объектами
  С помощью групп настроек реализуется правовой контроль
    
  # Ключи хешей всегда сохранять как символы!
=end
  
  before_filter :login_required
    
  # GET /roles
  def index
    @roles = Role.paginate(:all,
                           :order=>"created_at ASC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>3
                           )
                           
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /roles/1
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /roles/new
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    render :layout => 'roles'
  end

  # POST /roles
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = 'role успешно создано.'
        format.html { redirect_to(admins_role_path(@role)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /roles/1
  def update
    @role = Role.find(params[:id])
    
    # Если не установлено политики сохдадим ее и хеш
    unless params[:role]
      params[:role]= Hash.new
      params[:role][:settings]= Hash.new
    # Если установлено, убедимся в существовании набора политик
    else
      (params[:role][:settings]= Hash.new) unless params[:role][:settings]
    end
    
    # Получить базовую политику Class=>Hash
    base_role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : nil
        
    # Получиь политику из хеша параметров Class=>HashWithIndifferentAccess
    new_role= Hash.new
    new_role= params[:role][:settings]
    
    # Приведем исходные значения к значению по умолчанию
    base_role= base_role.recursive_set_values_on_default!
            
    # Накладываем новую политику на старую
    base_role.recursive_merge_with_default!(new_role)

    # Если в обработчик пришел массив политик
    # Параметны преобразуем в YAML и сохраняем как набор политик
    params[:role] ? params[:role][:settings]= base_role.to_yaml : nil
    
    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'role успешно обновлено.'
        format.html { redirect_back_or(admins_role_path(@role)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /roles/1
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(admins_roles_url) }
    end
  end
  
  # ===============================================================================
  def new_role_section
    @role = Role.find(params[:id])
    
    # Объект правовой политики является Хеш массивом, а не стандартным объектом Rails
    # На данный момент я выбрал прямой путь валидации
    # Вероятно, функция должна быть переработана в будущем 12:02 18.04.2009
    
    # Если имя установлено
    if params[:section_name].nil? || params[:section_name].blank?
      flash[:warning] = t('policies.empty_section_name')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Дубликат переменной
    section_name= params[:section_name].dup

    #Валидация на английские символы
    correct_section_name= section_name.match(Format::LATIN_AND_SAFETY_SYMBOLS) 
    unless correct_section_name
      flash[:warning] = t('policies.section_wrong_name')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Переведем в нижний регистр
    section_name.downcase!

    role_settings= @role.settings.is_a?(String) ? YAML::load(@role.settings) : nil
    role_settings= role_settings ? role_settings : Hash.new # если YAML не загружен, то будет пустой HASH
    
    unless role_settings
      flash[:warning] = t('policies.array_forming_error')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Если такая группа прав уже существует
    if role_settings[section_name.to_sym]
      flash[:warning] = t('policies.section_exists')
      redirect_back_or(admins_role_path(@role))
      return
    else
      role_settings[section_name.to_sym]= Hash.new
    end
    
    respond_to do |format|
      if @role.update_attributes({:settings=>role_settings})
        flash[:notice] = t('policies.section_create')
        format.html { redirect_back_or(admins_role_path(@role)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end #new_role_section
  
  def new_role_rule
    @role = Role.find(params[:id])

    if params[:section_rule].nil? || params[:section_name].nil?
      flash[:warning] = t('policies.data_are_required')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Переведем в нижний регистр
    params[:section_rule].downcase!
    
    #Валидация на английские символы
    correct_section_rule_name= params[:section_rule].match(Format::LATIN_AND_SAFETY_SYMBOLS) 
    unless correct_section_rule_name
      flash[:warning] = t('policies.section_rule_wrong_name') + params[:section_name]
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    role_settings= @role.settings.is_a?(String) ? YAML::load(@role.settings) : nil
    # Если по какой то причине получился nil, то пусть пользователь
    # сперва создаст группу, там хеш формируется почти принудительно и ошибка должна пропасть
    unless role_settings
      flash[:warning] = t('policies.try_to_create_section')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Если такого ключа нет (нет такой группы)
    unless role_settings.has_key?(params[:section_name].to_sym)
      flash[:warning] = t('policies.try_to_create_section')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    # Установить ключ со значением true    
    role_settings[params[:section_name].to_sym][params[:section_rule].to_sym]= true

    respond_to do |format|
      if @role.update_attributes({:settings=>role_settings})
        flash[:notice] = t('policies.section_rule_create')
        format.html { redirect_back_or(admins_role_path(@role)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end #new_role_rule
  
end