class StorageSectionsController < ApplicationController
  def index
    @storage_sections= StorageSection.find_all_by_user_id(@user.id)
    @storage_section= StorageSection.new
  end
  
  def show
    @storage_section= StorageSection.find_by_zip(params[:id])
    @storage_section_files= StorageFile.paginate_all_by_storage_section_id(@storage_section.id,
                           :order=>"created_at DESC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>20
                           )
  end
  
  def create
    @storage_section= StorageSection.new(params[:storage_section])
    zip= zip_for_model('StorageSection')
    @storage_section.zip= zip
    @storage_section.user_id= @user.id 
    respond_to do |format|
      if @storage_section.save
        flash[:notice] = 'Раздел создан'
        format.html { redirect_to(storage_sections_path) }
      else
        flash[:notice] = 'Ошибка при создании раздела хранилища файлов'
        format.html { redirect_to(storage_sections_path) }
      end
    end
  end
  
  protected
  
  def find_storage_section
    @storage_section= StorageSection.find_by_zip(params[:id])
    access_denied and return unless @storage_section
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

  def storage_section_resourсe_access_required
      access_denied if current_user.has_complex_resource_block_for?(@storage_section, :administrator, controller_name)
      return true   if current_user.has_complex_resource_access_for?(@storage_section, :administrator, controller_name)
      return true   if current_user.has_role_policy?(:administrator, controller_name)
      access_denied if current_user.has_complex_block?(:administrator, controller_name)
      return true   if current_user.has_complex_access?(:administrator, controller_name)
      access_denied if current_user.has_complex_resource_block_for?(@storage_section, controller_name, action_name)
      return true   if current_user.has_complex_resource_access_for?(@storage_section, controller_name, action_name)
      access_denied if current_user.has_complex_block?(controller_name, action_name)
      return true   if current_user.has_complex_access?(controller_name, action_name)
      return true   if current_user.has_role_policy?(controller_name, action_name) && current_user.is_owner_of?(@storage_section)
      access_denied
  end
end
