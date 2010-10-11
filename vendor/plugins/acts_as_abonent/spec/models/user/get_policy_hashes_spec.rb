require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '10:51 03.08.2009' do  
    # resources_policies_hash_for_class_of
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin)
      @admin.update_attribute(:role, @page_manager_role)
      
      @policy0= Factory.create(:page_manager_personal_policy, :user_id=>@admin.id)
      
      @policy1= Factory.create(:page_manager_personal_resource_policy, :user_id=>@admin.id)
      @policy1.resource= @admin
      @policy1.save
      
      @policy2= Factory.create(:page_manager_group_policy, :role_id=>@page_manager_role.id)
      
      @policy3= Factory.create(:page_manager_group_resource_policy, :role_id=>@page_manager_role.id)
      @policy3.resource= @admin
      @policy3.save
    end

    it '10:29 03.08.2009' do
      @admin.get_personal_policy_hash(:pages, :manager).should be_instance_of(Hash)
      @admin.get_personal_policy_hash(:pages, :manager)[:value].should be_true
      @admin.get_personal_policy_hash(:pages, :manager)[:counter].should eql(5)
    end

    it '10:30 03.08.2009' do      
      @admin.get_personal_policy_hash(:pages, :manager0).should be_nil
      @admin.get_personal_policy_hash(:pages0, :manager).should be_nil
    end
        
    it '10:31 03.08.2009' do
      @admin.get_personal_resource_policy_hash(@admin, :pages, :manager).should be_instance_of(Hash)
      @admin.get_personal_resource_policy_hash(@admin, :pages, :manager)[:value].should be_true
      @admin.get_personal_resource_policy_hash(@admin, :pages, :manager)[:counter].should eql(5)
    end
    
    it '10:32 03.08.2009' do
      @admin.get_personal_resource_policy_hash(@admin, :pages, :manager0).should be_nil
    end

    it '10:29 03.08.2009' do
      @admin.get_group_policy_hash(:pages, :manager).should be_instance_of(Hash)
      @admin.get_group_policy_hash(:pages, :manager)[:value].should be_true
      @admin.get_group_policy_hash(:pages, :manager)[:counter].should eql(5)
    end

    it '10:30 03.08.2009' do      
      @admin.get_group_policy_hash(:pages, :manager0).should be_nil
      @admin.get_group_policy_hash(:pages0, :manager).should be_nil
    end
        
    it '10:31 03.08.2009' do
      @admin.get_group_resource_policy_hash(@admin, :pages, :manager).should be_instance_of(Hash)
      @admin.get_group_resource_policy_hash(@admin, :pages, :manager)[:value].should be_true
      @admin.get_group_resource_policy_hash(@admin, :pages, :manager)[:counter].should eql(5)
    end
    
    it '10:32 03.08.2009' do
      @admin.get_group_resource_policy_hash(@admin, :pages, :manager0).should be_nil
    end
end
