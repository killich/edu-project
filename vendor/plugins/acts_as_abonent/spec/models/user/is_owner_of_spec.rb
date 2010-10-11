require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '11:31 01.08.2009' do  

    # ����������� ����� ������ ������ �������
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)

      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      @ivanov= Factory.create(:ivanov)
      
      @admin_profile= Factory.create(:empty_profile, :user_id=>@admin.id)
      @profile0= Factory.create(:empty_profile)
      
      # � ������������ ��� ������������ ��������
      @admin_policy= Factory.create(:page_tree_personal_policy_unlimited, :user_id=>@admin.id)
      @empty_policy= Factory.create(:page_tree_group_policy_unlimited)
    end
    
    # �������� ������ ���� =)
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@admin).should be_true
    end
    
    # �� ������� ������ �������������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@ivanov).should be_false
    end
    
    # � ������ ���� �������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@admin_profile).should be_true
    end
    
    # � ������ ���� �������� �������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@admin_policy).should be_true
    end
    
    # ��� �������� ������ �� �����������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@empty_policy).should be_false
    end
    
    # � ������� ��� 
    it '11:34 01.08.2009' do
      @ivanov.is_owner_of?(@admin_profile).should be_false
    end
    
    # ������ ������� ������ �� ������ � �������������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@page_manager_role).should be_false
    end
    
    # ������ ������� �� ����������� ������������
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(@profile0).should be_false
    end    
        
    # �������� nil, false, true
    it '11:34 01.08.2009' do
      @admin.is_owner_of?(nil).should be_false
      @admin.is_owner_of?(false).should be_false
      @admin.is_owner_of?(true).should be_false
    end
end
