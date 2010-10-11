require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:18 18.07.2009' do
    before(:each) do
      # ����� � �������� ������� ����
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
    end
    
    def create_group_policies
      # ������� 2 ��������� �������� ��� ������� ������������
      @page_manager_policy= Factory.create(:page_manager_group_policy_unlimited, :role_id=>@admin.role.id)
      @page_tree_policy=    Factory.create(:page_tree_group_policy_unlimited,    :role_id=>@admin.role.id)
    end
    
    # 2 ��������� ����� ��� ���������� �����������
    it '9:17 15.07.2009' do
      create_group_policies
      
      @admin.has_group_access?(:pages, :tree).should     be_true
      @admin.has_group_access?(:pages, :manager).should  be_true
      
      @admin.has_group_access?('pages', :tree).should      be_true
      @admin.has_group_access?('pages', 'manager').should  be_true
      
      @admin.group_policy_exists?('pages', 'manager').should  be_true
      @admin.group_policy_exists?('pages0', 'manager').should  be_false
      
      @admin.has_group_access?(:pages0, :tree).should    be_false
      @admin.has_group_access?(:pages, :duck).should     be_false
    end#9:17 15.07.2009

    # � ������������ ��� �� ����� ��������� ��������
    it '14:29 16.07.2009' do
      # ������� �������� ����
      @admin.role_policies_hash.should  be_instance_of(Hash)
      @admin.role_policies_hash.should  have(2).items
      
      # ��������� ������� ���
      @admin.create_group_policies_hash.should  be_instance_of(Hash)
      @admin.create_group_policies_hash.should  be_empty
      
      # ����� ���� �� ���������� - ������� false
      @admin.has_group_access?('pages', 'tree').should   be_false
      @admin.has_group_access?(:pages, :manager).should  be_false
      @admin.has_group_access?(:pages, 'manager').should be_false
      @admin.has_group_access?(:pages0, :tree).should    be_false
      @admin.has_group_access?(:pages, :duck).should     be_false
    end#14:29 16.07.2009

    # �������
    
    # ����������� ����������� ����������� �� ���-�� ��� �������
    it '11:48 15.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:counter=>15, :max_count=>14)
      @admin.has_group_access?(:pages, :manager).should be_false
    end
    
    # ������� �� ����������
    it '12:38 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:counter=>nil, :max_count=>14)
      @admin.has_group_access?(:pages, :manager).should be_true
    end
    
    # �������� �������� �� ����������
    it '12:39 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:counter=>10, :max_count=>nil)
      @admin.has_group_access?(:pages, :manager).should be_true
    end

    # ������� �������
    it '12:40 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:counter=>10, :max_count=>10)
      @admin.has_group_access?(:pages, :manager).should be_true
    end
    
    # �����
    
    # ��������� �����
    it '11:48 15.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-2.seconds, :finish_at=>DateTime.now-1.second)
      @admin.has_group_access?(:pages, :manager).should be_false
    end
    
    # ����� �� �����������
    it '12:38 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:start_at=>nil, :finish_at=>nil)
      @admin.has_group_access?(:pages, :manager).should be_true
    end
    
    # �������� ������� �� ����������
    it '12:39 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>nil)
      @admin.has_group_access?(:pages, :manager).should be_true
    end

    # ������� ����� �������
    it '12:40 19.07.2009' do
      create_group_policies
      @page_manager_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>DateTime.now+10.seconds)
      @admin.has_group_access?(:pages, :manager).should be_true
    end
    
    # �������� ���� �������
    
    it '12:49 19.07.2009' do
      create_group_policies
      @admin.has_group_access?(:pages, :manager).should  be_true
      @admin.has_group_access?(:pages, :tree).should     be_true
      
      # ��� �������� ���������
      @page_tree_policy.update_attribute(:value, false)
      @page_manager_policy.update_attribute(:value, false)
      
      # ��� �� ����������
      @admin.has_group_access?(:pages, :manager).should  be_true
      @admin.has_group_access?(:pages, :tree).should     be_true
      
      # ��� ����������
      @admin.has_group_access?(:pages, :tree, :recalculate=> true).should  be_false
      @admin.has_group_access?(:pages, :manager).should  be_false
    end
end
