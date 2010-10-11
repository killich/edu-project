require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '12:35 28.07.2009' do  
    # ����������� ����� ������ ������ �������
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin, :role_id=>@page_manager_role.id)
      
      # � ������������ ��� ������������ ��������
      @page_tree_policy= Factory.create(:page_tree_personal_policy_unlimited,       :user_id=>@admin.id)
      @page_manager_policy= Factory.create(:page_manager_personal_policy_unlimited, :user_id=>@admin.id)
    end
    
    # ����������� ���� - �������� ���������� �� �����
    it '18:14 28.07.2009' do
      @admin.has_personal_access?(:pages, :tree).should be_true
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>DateTime.now+10.second)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_true
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_true
      @page_tree_policy.update_attributes(:counter=>11, :max_count=>10)
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
    end
    
    # ������� �� �������������, ���� ������ ���������
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # ��������� - ��������� �������
      @admin.has_personal_access?(:pages, :tree).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
      
      @admin.has_personal_access?(:pages, :tree).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
    end
    
    # ������� �� �������������, ���� ��� �� ������ ���������, �� ����� ��� �� ��������� �� �������
    it '21:47 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>7, :max_count=>10)
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now-1.second)
      # �������� ����
      @admin.has_personal_access?(:pages, :tree).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(7)
    end
    
    # ������� �������� �� ������� � �������������
    # ����� �� �������� � �� �������������
    it '21:47 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>6, :max_count=>10)
      
      # �������� �� �������
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now+10.second)
      
      # �������� ����
      @admin.has_personal_access?(:pages, :tree).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(7)
      
      # �� �������� �� �������
      @page_tree_policy.update_attributes(:start_at=>DateTime.now-10.second, :finish_at=>DateTime.now-1.second)
      
      # ��������� � �� ������ - �������� ��� �� ��������, �� ��� ��� �� �������� � ������ �� ���� �� �����
      @admin.has_personal_access?(:pages, :tree).should be_true
      
      # � ������ ��� ���������� - � �������� ��������� ���� ����������
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
    end
    
    # ������������� �������� �� 1 >
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # ��������� - ��������� �������
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>5).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(15)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true).should be_false
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(15)
    end
    
    # ������������� �������� �� 1 <
    it '18:14 28.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # ��������� - ��������� �������
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>-1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(9)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>-1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(8)
    end
    
    # ������ ������������� :counter_increment=>0
    it '21:41 31.07.2009' do
      @page_tree_policy.update_attributes(:counter=>10, :max_count=>10)
      
      # ��������� - ��������� �������
      @admin.has_personal_access?(:pages, :tree, :counter_increment=>0).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(10)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>0).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(10)
      
      @admin.has_personal_access?(:pages, :tree, :recalculate=>true, :counter_increment=>1).should be_true
      @admin.instance_variable_get('@personal_policies_hash')[:pages][:tree][:counter].should eql(11)
    end
end
