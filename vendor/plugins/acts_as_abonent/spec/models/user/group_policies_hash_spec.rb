require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:16 18.07.2009' do
    # ����������� ����� ������ ������ �������
    before(:each) do
      # ����� � �������� ������� ����
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
    end
  
    def create_group_policies
      # ������� 2 ��������� �������� ��� ������� ������������(����)
      @page_manager_gpolicy=  Factory.create(:page_manager_group_policy,  :role_id=>@page_manager_role.id)
      @page_tree_gpolicy=     Factory.create(:page_tree_group_policy,     :role_id=>@page_manager_role.id)
    end
    
    # � ������������ ��� ���� (������)
    # ������ - ���������� �������� ��������� ��������
    it '14:40 16.07.2009' do
      @admin.update_attribute(:role, nil)
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      @admin.create_group_policies_hash.should be_empty
    end#14:40 16.07.2009
    
    # � ������������ ���� ���� (������)
    # ����� ������� - ������
    it '15:54 16.07.2009' do
      # ������� ���� � ������ � ���� �����
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      @admin.create_group_policies_hash.should be_empty
    end#15:54 16.07.2009
    
    # � ������������ ���� ���� (������)
    # ���� ��������� ��������
    it '16:00 16.07.2009' do
      create_group_policies
      # ������ ����  ��������� ��������
      GroupPolicy.find_all_by_role_id(@admin.role.id).should have(2).items
      @admin.create_group_policies_hash.should be_instance_of(Hash)
      
      # ������ ���� ���� ������ pages � ��� 2 ������ � ���������
      @admin.create_group_policies_hash.should have(1).items
      @admin.create_group_policies_hash[:pages].should have(2).items
    end#16:00 16.07.2009
end
