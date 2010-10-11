require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:21 18.07.2009' do  
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      
      @admin= Factory.create(:admin)
      @ivanov= Factory.create(:ivanov)
      @petrov= Factory.create(:petrov)
      
      @admin.update_attribute(:role_id, @page_manager_role.id)
    end

    def admin_has_resources
      @resource_ivanov=Factory.create(:page_manager_group_resource_policy_unlimited, :role_id=>@admin.role.id)
      @resource_ivanov.resource= @ivanov
      @resource_ivanov.save
      
      @resource_petrov=Factory.create(:page_manager_group_resource_policy_unlimited, :role_id=>@admin.role.id)
      @resource_petrov.resource= @petrov
      @resource_petrov.save
      
      # ��� �������� ��������� �� ����������
      @resource_ivanov.update_attribute(:value, false)
      @resource_petrov.update_attribute(:value, false)
    end    
    
    # � ������������ ��� ������������ ������� � ��������
    it '13:05 17.07.2009' do
      @admin.has_group_resource_block_for?(@ivanov, :profile, :edit, :recalculate=>true).should be_false
      @admin.has_group_resource_block_for?(@petrov, :profile, :edit, :recalculate=>true).should be_false
    end
    
    # ��������� ������� �������� ���� ������������ ������� � ��������
    it '13:05 17.07.2009' do
      #@admin.group_resources_policies_hash.should be_instance_of(Hash)
      #@admin.group_resources_policies_hash.should  be_empty
    end
    
    # � ������������� ��� ������������ ������� � ��������
    # ��� ������������ ������� � ������ �������� - ����
    it '15:29 19.07.2009' do
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      #@admin.group_resources_policies_hash.should have(1).item
      
      #@admin.group_resources_policies_hash[:User].should be_instance_of(Hash)
      #@admin.group_resources_policies_hash[:User].should be_empty
    end
    
    # ��� ������������ ������� � ������ ��������
    it '15:29 19.07.2009' do
      admin_has_resources
      
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      #@admin.group_resources_policies_hash.should have(1).item
      
      #@admin.group_resources_policies_hash[:User].should be_instance_of(Hash)
      #@admin.group_resources_policies_hash[:User].should have(2).item
    end
    
    # ����� ��� ��������
    it '15:36 19.07.2009' do
      admin_has_resources
      
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
      @admin.has_group_resource_block_for?(@petrov, :pages, :manager).should be_true
      
      @admin.has_group_resource_block_for?(@petrov, 'pages', 'manager').should be_true
      @admin.has_group_resource_block_for?(@ivanov, :pages, 'manager').should be_true
      @admin.has_group_resource_block_for?(@petrov, 'pages', :manager).should be_true

      @admin.has_group_resource_block_for?(@admin, :page, :manager).should be_false
    end
    
    # �������
    
    # ����������� ����������� ����������� �� ���-�� ��� �������
    it '11:48 15.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:counter=>15, :max_count=>14)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_false
    end
    
    # ������� �� ����������
    it '12:38 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:counter=>nil, :max_count=>14)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end
    
    # �������� �������� �� ����������
    it '12:39 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:counter=>10, :max_count=>nil)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end

    # ������� �������
    it '12:40 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:counter=>10, :max_count=>10)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end
    
    # �����
    
    # ��������� �����
    it '11:48 15.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:start_at=>DateTime.now-2.seconds, :finish_at=>DateTime.now-1.second)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_false
    end
    
    # ����� �� �����������
    it '12:38 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:start_at=>nil, :finish_at=>nil)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end
    
    # �������� ������� �� ����������
    it '12:39 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>nil)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end

    # ������� ����� �������
    it '12:40 19.07.2009' do
      admin_has_resources
      @resource_ivanov.update_attributes(:start_at=>DateTime.now-1.second, :finish_at=>DateTime.now+10.second)
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
    end
    
    # �������� ���� �������
    
    it '12:49 19.07.2009' do
      admin_has_resources
      
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
      @admin.has_group_resource_block_for?(@petrov, :pages, :manager).should be_true
            
      # ��� �������� ���������
      @resource_ivanov.update_attribute(:value, true)
      @resource_petrov.update_attribute(:value, true)
      
      # ��� �� ����������
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager).should be_true
      @admin.has_group_resource_block_for?(@petrov, :pages, :manager).should be_true
      
      # ��� ����������
      @admin.has_group_resource_block_for?(@ivanov, :pages, :manager, :recalculate=> true).should be_false
      @admin.has_group_resource_block_for?(@petrov, :pages, :manager).should be_false
    end
end
