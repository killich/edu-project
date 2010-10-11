require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '12:35 28.07.2009' do  
    # Исполняется перед каждым тестом раздела
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      
      # У пользователя две персональные политики
      @page_tree_policy= Factory.create(:page_tree_personal_policy_unlimited,       :user_id=>@admin.id)
      @page_manager_policy= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
      
      # У пользователя две групповые политики
      @page_tree_policy_g= Factory.create(:page_tree_group_policy_unlimited,       :role_id=>@admin.role.id)
      @page_manager_policy_g= Factory.create(:page_manager_group_policy_unlimited, :role_id=>@admin.role.id)
    end
    
    it '9:18 09.08.2009' do
      @admin.personal_policy_exists?('pages', 'tree').should be_true
      @admin.personal_policy_exists?('pages', 'manager').should be_true
      
      @admin.personal_policy_exists?('pages', 'tree1').should be_false
      @admin.personal_policy_exists?('pages2', 'manager').should be_false
    end
    
    it '9:26 09.08.2009' do
      @admin.group_policy_exists?('pages', 'tree').should be_true
      @admin.group_policy_exists?('pages', 'manager').should be_true
      
      @admin.group_policy_exists?('page', 'tree').should be_false
      @admin.group_policy_exists?('pagess', 'manager').should be_false
    end
end
