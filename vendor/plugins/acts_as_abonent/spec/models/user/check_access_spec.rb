require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:02 18.07.2009' do  

    # ����������� ����� ������ ������ �������
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      # � ������������ ��� ������������ ��������
      @unlim_policy= Factory.create(:page_tree_personal_policy_unlimited,     :user_id=>@admin.id)
      @unlim_policy1= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end
    
    # �������� ������� ������� �������� ������� ��� ������/������������ �� ����������
    # ��������� || ��������������� ������ ������������� �����
    it '23:40 16.07.2009' do
      # � ������������ ��� ������������ ��������
      @admin.check_policy(:pages, :tree, 'personal_policies_hash', :recalculate=>true)
      @admin.check_policy(:pages, :manager, 'personal_policies_hash', :recalculate=>true)
    end#23:40 16.07.2009
    
end
