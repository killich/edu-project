class Admins::RoleSectionController < ApplicationController

=begin
  Функционал для работы с разделами настроек
  
  # Ключи хешей всегда сохранять как символы!

=end

  # взять набор и перевести его в хеш
  # Обнулить раздел 
  # перевести в YAML
  # сохранить
  
  before_filter :login_required
  
  def destroy
    @role = Role.find(params[:role_id])
    section_name= params[:id].dup
        
    # Если кодер установил пустое имя раздела прав    
    if section_name.blank?
      flash[:warning] =  t('policies.empty_section_name')
      redirect_to admins_roles_path
      return
    end
    
    # Получить базовую политику Class=>Hash
    base_role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    base_role= base_role ? base_role : Hash.new
    # Удалить раздел (ключ)
    base_role.delete(section_name.to_sym)
    # полиику сереализировать
    base_role= base_role.to_yaml
    
    respond_to do |format|
      if @role.update_attributes({:settings=>base_role})
        flash[:notice] = t('policies.section_destroy')
        format.html { redirect_back_or(admins_role_path(@role)) }
      else
        format.html { render :action => "edit" }
      end
    end    
  end #destroy
  
  def delete_rule
    @role = Role.find(params[:role_id])
    
    if params[:id].blank? || params[:name].blank?
      flash[:warning] = t('policies.data_are_required')
      redirect_back_or(admins_role_path(@role))
      return
    end
    section_name= params[:id].dup
    rule_name= params[:name].dup
    
    # Получить базовую политику Class=>Hash
    base_role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    base_role= base_role ? base_role : Hash.new
    
    # Если вдруг оказалось не хешем, то сообщим об этом
    unless base_role[section_name.to_sym].is_a?(Hash)
      flash[:warning] = t('policies.section_is_not_hash')
      redirect_back_or(admins_role_path(@role))
      return
    end
    
    unless base_role[section_name.to_sym].has_key?(rule_name.to_sym)
      flash[:warning] = t('policies.section_hasnt_rule')
      redirect_back_or(admins_role_path(@role))
      return
    end
    base_role[section_name.to_sym].delete(rule_name.to_sym)
    # полиику сереализировать
    base_role= base_role.to_yaml
    
    respond_to do |format|
      if @role.update_attributes({:settings=>base_role})
        flash[:notice] = t('policies.section_rule_destroy')
        format.html { redirect_back_or(admins_role_path(@role)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end #delete_rule
end
