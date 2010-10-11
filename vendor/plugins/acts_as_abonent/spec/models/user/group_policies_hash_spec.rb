require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:16 18.07.2009' do
    # Исполняется перед каждым тестом раздела
    before(:each) do
      # Админ с базовыми правами роли
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
    end
  
    def create_group_policies
      # Создать 2 групповых политики для данного пользователя(роли)
      @page_manager_gpolicy=  Factory.create(:page_manager_group_policy,  :role_id=>@page_manager_role.id)
      @page_tree_gpolicy=     Factory.create(:page_tree_group_policy,     :role_id=>@page_manager_role.id)
    end
    
    # У пользователя нет роли (группы)
    # Значит - невозможно получить групповые политики
    it '14:40 16.07.2009' do
      @admin.update_attribute(:role, nil)
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      @admin.create_group_policies_hash.should be_empty
    end#14:40 16.07.2009
    
    # У пользователя есть роль (группа)
    # Набор политик - пустой
    it '15:54 16.07.2009' do
      # Создать роль и админа с этой ролью
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      @admin.create_group_policies_hash.should be_empty
    end#15:54 16.07.2009
    
    # У пользователя есть роль (группа)
    # Есть групповые политики
    it '16:00 16.07.2009' do
      create_group_policies
      # Должны быть  групповые политики
      GroupPolicy.find_all_by_role_id(@admin.role.id).should have(2).items
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      
      # Должен быть один раздел pages в нем 2 записи о политиках
      @admin.create_group_policies_hash.should have(1).items
      @admin.create_group_policies_hash[:pages].should have(2).items
    end#16:00 16.07.2009
end
