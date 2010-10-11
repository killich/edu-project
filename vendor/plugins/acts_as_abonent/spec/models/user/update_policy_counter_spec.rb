require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '12:35 28.07.2009' do  
    # Исполняется перед каждым тестом раздела
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      
      # У пользователя две персональные политики
      @page_tree_policy= Factory.create(:page_tree_personal_policy_unlimited,       :user_id=>@admin.id)
      @page_manager_policy= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end
    
    # Проверочный тест - нагрузги фактически не несет
    it '18:14 28.07.2009' do
      @admin.has_personal_access?(:pages, :tree).should be_true
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>DateTime.now+10.second)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_true
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_true
      @page_tree_policy.update_attributes(:counter=>11, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
    end
    
    # Счетчик не увеличивается, если достиг максимума
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # Проверили - увеличили счетчик
      @admin.has_personal_access?(:pages, :tree).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
      
      @admin.has_personal_access?(:pages, :tree).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
    end
    
    # Счетчик не увеличивается, если еще не достиг максимума, но права уже не актуалены по времени
    it '21:47 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>7, :max_count=>10)
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now-1.second)
      # Проверка прав
      @admin.has_personal_access?(:pages, :tree).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(7)
    end
    
    # Счетчик актуален по времени и увеличивается
    # Потом не актуален и не увеличивается
    it '21:47 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>6, :max_count=>10)
      
      # Актуален по времени
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now+10.second)
      
      # Проверка прав
      @admin.has_personal_access?(:pages, :tree).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(7)
      
      # Не актуален по времени
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now-1.second)
      
      # Изменение в БД прошло - политика уже не акуальна, но хеш еще не обновлен и ничего об этом не знает
      @admin.has_personal_access?(:pages, :tree).should be_true
      
      # А теперь хеш пересчитан - и политика перестала быть актуальной
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
    end
    
    # Инкрементация отличная от 1 >
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # Проверили - увеличили счетчик
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>5).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(15)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(15)
    end
    
    # Инкрементация отличная от 1 <
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # Проверили - увеличили счетчик
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>-1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(9)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>-1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
    end
    
    # Запрет инкрементации :counter_increment=>0
    it '21:41 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # Проверили - увеличили счетчик
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>0).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(10)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>0).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(10)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
    end
end
