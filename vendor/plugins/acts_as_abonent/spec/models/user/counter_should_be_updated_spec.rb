require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '12:35 28.07.2009' do  

    # Исполняется перед каждым тестом раздела
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)

      # У пользователя две персональные политики
      @page_tree_policy= Factory.create(:page_tree_personal_policy_unlimited,     :user_id=>@admin.id)
      @page_manager_policy= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end

    # Нет значений счетчика
    it '13:03 28.07.2009' do
      @admin.has_personal_access?(:pages, :tree).should be_true
      policy_hash= @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree]
      
      @admin.counter_should_be_updated?(policy_hash).should be_false
    end
    
    # Нет счетчика
    it '13:04 28.07.2009' do
      @page_tree_policy.update_attributes(:max_count=>11)
      @admin.has_personal_access?(:pages, :tree).should be_true
      policy_hash= @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree]
      
      @admin.counter_should_be_updated?(policy_hash).should be_false
    end
    
    # Нет максимума счетчика
    it '13:05 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10)
      @admin.has_personal_access?(:pages, :tree).should be_true
      policy_hash= @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree]
      
      @admin.counter_should_be_updated?(policy_hash).should be_false
    end

    # Есть значения счетчика и они актуальны
    it '13:06 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>9, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree).should be_true # counter=>10
      policy_hash= @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree]
      @admin.counter_should_be_updated?(policy_hash).should be_true
      @admin.has_personal_access?(:pages, :tree).should be_true # counter=>11
      @admin.counter_should_be_updated?(policy_hash).should be_false
    end
        
    # Есть значения счетчика и они не актуальны по счетчику
    it '13:06 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>11, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree).should be_false
      
      policy_hash= @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree]
      @admin.counter_should_be_updated?(policy_hash).should be_false
    end
end
