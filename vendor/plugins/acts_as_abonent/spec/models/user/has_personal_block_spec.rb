require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:13 18.07.2009' do
    before(:each) do
      # Админ с базовыми правами роли
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
    end
    
    def create_personal_policies
      # Создать 2 персональных политики для данного пользователя
      @page_manager_policy= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
      @page_tree_policy=    Factory.create(:page_tree_personal_policy_unlimited,    :user_id=>@admin.id)
      # Сделать из политик - блокировку
      @page_tree_policy.update_attribute(:value, false)
      @page_manager_policy.update_attribute(:value, false)
    end
    
    # 2 персональных блокировки без временного ограничения
    it '9:17 15.07.2009' do
      create_personal_policies
      
      @admin.has_personal_block?(:pages, :tree).should     be_true
      @admin.has_personal_block?(:pages, :manager).should  be_true
      
      @admin.has_personal_block?('pages', :tree).should      be_true
      @admin.has_personal_block?('pages', 'manager').should  be_true
      
      @admin.has_personal_block?(:pages0, :tree).should    be_false
      @admin.has_personal_block?(:pages, :duck).should     be_false
    end#9:17 15.07.2009

    # У пользователя нет ни одной персональной политики
    it '14:29 16.07.2009' do
      # Ролевые политики есть
      @admin.role_policies_hash.should  be_instance_of(Hash)
      @admin.role_policies_hash.should  have(2).items
      
      # персональных блокировок нет
      @admin.create_personal_policies_hash.should  be_instance_of(Hash)
      @admin.create_personal_policies_hash.should  be_empty
      
      # Таких блокировок не существует - вернуть false
      @admin.has_personal_block?('pages', 'tree').should   be_false
      @admin.has_personal_block?(:pages, :manager).should  be_false
      @admin.has_personal_block?(:pages, 'manager').should be_false
      @admin.has_personal_block?(:pages0, :tree).should    be_false
      @admin.has_personal_block?(:pages, :duck).should     be_false
    end#14:29 16.07.2009

    # Счетчик
    
    # Установлено превышенное ограничение по кол-ву раз доступа
    it '11:48 15.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:counter=>15, :max_count=>14)
      @admin.has_personal_block?(:pages, :manager).should be_false
    end
    
    # Счетчик не установлен
    it '12:38 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:counter=>nil, :max_count=>14)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end
    
    # Максимум счетчика не установлен
    it '12:39 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:counter=>10, :max_count=>nil)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end

    # Рабочий счетчик
    it '12:40 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:counter=>10, :max_count=>10)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end
    
    # Время
    
    # Превышено время
    it '11:48 15.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-2.seconds, :finish_at=>DateTime.now-1.second)
      @admin.has_personal_block?(:pages, :manager).should be_false
    end
    
    # Время не установлено
    it '12:38 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:start_at=>nil, :finish_at=>nil)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end
    
    # Максимум времени не установлен
    it '12:39 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>nil)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end

    # Рабочие рамки времени
    it '12:40 19.07.2009' do
      create_personal_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>DateTime.now+10.second)
      @admin.has_personal_block?(:pages, :manager).should be_true
    end
    
    # Пересчет хеша политик
    
    it '12:49 19.07.2009' do
      create_personal_policies
      @admin.has_personal_block?(:pages, :manager).should  be_true
      @admin.has_personal_block?(:pages, :tree).should     be_true
      
      # Обе блокировки обновлены
      @page_tree_policy.update_attribute(:value, true)
      @page_manager_policy.update_attribute(:value, true)
      
      # хеш не пересчитан
      @admin.has_personal_block?(:pages, :manager).should  be_true
      @admin.has_personal_block?(:pages, :tree).should     be_true
      
      # хеш пересчитан
      @admin.has_personal_block?(:pages, :tree, :recalculate=> true).should  be_false
      @admin.has_personal_block?(:pages, :manager).should  be_false
    end
end
