require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:00 18.07.2009' do  

    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      # � ������������ ��� ������������ ��������
      @unlim_policy= Factory.create(:page_tree_personal_policy_unlimited,     :user_id=>@admin.id)
      @unlim_policy1= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end

    # ������ ������� �������� ������������ �������
    it '10:29 17.07.2009' do
      # ��� ����������� �� �������
      @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true

      # ������� �������
        # ��������������
        @unlim_policy.update_attribute(:finish_at, DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
        # �� ��������������
        @unlim_policy.update_attribute(:finish_at, DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      
      # � ��������
      @unlim_policy.update_attributes(:start_at=>nil, :finish_at=>nil)
      
      # ������ �������
        # ��������������
        @unlim_policy.update_attribute(:start_at, DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
        # �� ��������������
        @unlim_policy.update_attribute(:start_at, DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
        
      # �������������� ��������
        @unlim_policy.update_attributes(:start_at=>DateTime.now-1.minute, :finish_at=>DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_true
      # ��� �� �������
        @unlim_policy.update_attributes(:start_at=>DateTime.now+1.minute, :finish_at=>DateTime.now+2.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # ��� ����������
        @unlim_policy.update_attributes(:start_at=>DateTime.now-2.minute, :finish_at=>DateTime.now-1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # ��������� ������� ���� ��������� ������ ���� ������
        @unlim_policy.update_attributes(:start_at=>DateTime.now+2.minute, :finish_at=>DateTime.now-2.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # ��������� ������� ���� ��������� ������ ���� ������ - ��� ���� �������
        @unlim_policy.update_attributes(:start_at=>DateTime.now+2.minute, :finish_at=>DateTime.now+1.minute)
        @admin.policy_actual_by_time?(@unlim_policy.start_at, @unlim_policy.finish_at).should be_false
      # ��������� ������� ������ � ��������� ������� - ������ ������.
        @unlim_policy.update_attributes(:start_at=>DateTime.now, :finish_at=>DateTime.now)
    end#10:29 17.07.2009
    
end
