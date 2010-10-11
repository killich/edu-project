require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:02 18.07.2009' do  

    # Исполняется перед каждым тестом раздела
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      # У пользователя две персональные политики
      @unlim_policy= Factory.create(:page_tree_personal_policy_unlimited,     :user_id=>@admin.id)
      @unlim_policy1= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end
    
    # Проверка реакции функции проверки политик для группы/пользователя на отсутствие
    # временных || колличественных границ использования права
    it '23:40 16.07.2009' do
      # У пользователя две персональные политики
      @admin.check_policy(:pages, :tree, 'personal_policies_hash', :recalculate=>true)
      @admin.check_policy(:pages, :manager, 'personal_policies_hash', :recalculate=>true)
    end#23:40 16.07.2009
    
end
