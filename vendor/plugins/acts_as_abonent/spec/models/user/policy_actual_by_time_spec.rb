require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:00 18.07.2009' do  

    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      # У пользователя две персональные политики
      @unlim_policy= Factory.create(:page_tree_personal_policy_unlimited,     :user_id=>@admin.id)
      @unlim_policy1= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end

    # Работа функции проверки актуальности времени
    it '10:29 17.07.2009' do
      # Нет ограничений по времени
      @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true

      # Верхняя граница
        # Действительная
        @unlim_policy.update_attribute(:finish_at, DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
        # Не действительная
        @unlim_policy.update_attribute(:finish_at, DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      
      # В исходную
      @unlim_policy.update_attributes(:start_at=>nil, :finish_at=>nil)
      
      # Нижняя граница
        # Действительная
        @unlim_policy.update_attribute(:start_at, DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
        # Не действительная
        @unlim_policy.update_attribute(:start_at, DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
        
      # Действительный интервал
        @unlim_policy.update_attributes(:start_at=>DateTime.now-1.minute, :finish_at=>DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
      # Еще не начался
        @unlim_policy.update_attributes(:start_at=>DateTime.now+1.minute, :finish_at=>DateTime.now+2.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # Уже закончился
        @unlim_policy.update_attributes(:start_at=>DateTime.now-2.minute, :finish_at=>DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # Ошибочная ситуаця дата окончания меньше даты начала
        @unlim_policy.update_attributes(:start_at=>DateTime.now+2.minute, :finish_at=>DateTime.now-2.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # Ошибочная ситуаця дата окончания меньше даты начала - еще один вариант
        @unlim_policy.update_attributes(:start_at=>DateTime.now+2.minute, :finish_at=>DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # Ошибочная ситуаця начало и окончание правила - именно сейчас.
        @unlim_policy.update_attributes(:start_at=>DateTime.now, :finish_at=>DateTime.now)
    end#10:29 17.07.2009
    
end
