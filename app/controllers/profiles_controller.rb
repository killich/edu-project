class ProfilesController < ApplicationController

  before_filter :login_required
  before_filter :find_profile, :only=>[:update]

  # Имя пользователя
  def name
    @user= User.find_by_id(params[:id])
    @user.update_attribute(:name, params[:user][:name])
    flash[:notice]= 'Имя успешно обновлено'
    redirect_to(profile_users_path(:subdomain=>@subdomain)) and return
  end

  # Аватара пользователя
  def avatar
    @user= User.find_by_id(params[:id])
    # Если нет данных о пользователе или Аватаре
    if !params[:user] || !params[:user][:avatar]
      flash[:notice]= 'Изображение не установлено'
      redirect_to(profile_users_path(:subdomain=>@subdomain)) and return
    end
    
    @user.avatar= params[:user][:avatar]
    extension = File.extname(@user.avatar_file_name)
    @user.avatar.instance_write(:file_name, "#{Digest::SHA1.hexdigest(@user.login+Time.now.to_s)}#{extension}") 
    
    respond_to do |format|
      if @user.save
        flash[:notice]= 'Аватара успешно обновлена'
        format.html { redirect_to(profile_users_path(:subdomain=>@subdomain)) }
      else
        flash[:error]= 'Ошибка валидации'
        @profile= @user.profile
        format.html { render  :template => "users/profile" }
      end
    end
  end
  
  # Анкета пользователя
  def update
    @profile.update_attributes(params[:profile])
    flash[:notice]= 'Профайл успешно обновлен'
    redirect_to(profile_users_path(:subdomain=>@subdomain))
  end
      
  protected
  
  # Поиск ресурса
  def find_profile
    @profile= Profile.find_by_id(params[:id])
    access_denied and return unless @profile
  end
  
  def access_to_controller_action_required
    access_denied if current_user.has_complex_block?(:administrator, controller_name)
    return true   if current_user.has_complex_access?(:administrator, controller_name)
    return true   if current_user.has_role_policy?(:administrator, controller_name)
    access_denied if current_user.has_complex_block?(controller_name, action_name)
    return true   if current_user.has_complex_access?(controller_name, action_name) && current_user.is_owner_of?(@user)
    return true   if current_user.has_role_policy?(controller_name, action_name) && current_user.is_owner_of?(@user)
    access_denied
  end

  def profile_resourсe_access_required
      access_denied if current_user.has_complex_resource_block_for?(@profile, :administrator, controller_name)
      return true   if current_user.has_complex_resource_access_for?(@profile, :administrator, controller_name)
      return true   if current_user.has_role_policy?(:administrator, controller_name)
      access_denied if current_user.has_complex_block?(:administrator, controller_name)
      return true   if current_user.has_complex_access?(:administrator, controller_name)
      access_denied if current_user.has_complex_resource_block_for?(@profile, controller_name, action_name)
      return true   if current_user.has_complex_resource_access_for?(@profile, controller_name, action_name)
      access_denied if current_user.has_complex_block?(controller_name, action_name)
      return true   if current_user.has_complex_access?(controller_name, action_name)
      return true   if current_user.has_role_policy?(controller_name, action_name) && current_user.is_owner_of?(@profile)
      access_denied
  end
end
