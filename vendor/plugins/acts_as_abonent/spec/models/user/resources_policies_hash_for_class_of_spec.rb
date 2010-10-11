require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '9:58 20.07.2009' do  
    # resources_policies_hash_for_class_of
    before(:each) do
      @page_manager_role= Factory.create(:page_manager_role)
      @admin= Factory.create(:admin)
      @admin.update_attribute(:role_id, @page_manager_role.id)
      
      @ivanov= Factory.create(:ivanov)
      @petrov= Factory.create(:petrov)
    end

    def admin_has_resources
      @p_resource_ivanov=Factory.create(:page_manager_personal_resource_policy_unlimited, :user_id=>@admin.id)
      @p_resource_ivanov.resource= @ivanov
      @p_resource_ivanov.save
      
      @p_resource_petrov=Factory.create(:page_manager_personal_resource_policy_unlimited, :user_id=>@admin.id)
      @p_resource_petrov.resource= @petrov
      @p_resource_petrov.save
      
      
      @g_resource_ivanov=Factory.create(:page_manager_group_resource_policy_unlimited, :role_id=>@admin.role.id)
      @g_resource_ivanov.resource= @ivanov
      @g_resource_ivanov.save
      
      @g_resource_petrov=Factory.create(:page_manager_group_resource_policy_unlimited, :role_id=>@admin.role.id)
      @g_resource_petrov.resource= @petrov
      @g_resource_petrov.save
    end    
    
    # У пользователя нет персональных политик к ресурсам
    it '13:05 17.07.2009' do
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      
      # personal_resources_policies_hash_for_class_of(@ivanov)
      opt= {
       :finder=>'PersonalResourcePolicy.find_all_by_user_id_and_resource_type(self.id, resource_class)',
       :hash_name=>'personal_resources_policies_hash'
      }    
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      
      # group_resources_policies_hash_for_class_of(@ivanov)
      opt= {
       :finder=>'PersonalResourcePolicy.find_all_by_user_id_and_resource_type(self.id, resource_class)',
       :hash_name=>'personal_resources_policies_hash',
       :before_find=>'(@group_resources_policies_hash[resource_class.to_sym]= result_hash and return @group_resources_policies_hash) unless self.role'
      }
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should have(1).item
    end
 
    # У пользователя есть персональные политики к ресурсам
    it '13:05 17.07.2009' do
      admin_has_resources
      
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should be_instance_of(Hash)
      
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      
      @admin.personal_resources_policies_hash_for_class_of(@ivanov)[:User].should have(2).item
      @admin.group_resources_policies_hash_for_class_of(@ivanov)[:User].should have(2).item
      
      # personal_resources_policies_hash_for_class_of(@ivanov)
      opt= {
       :finder=>'PersonalResourcePolicy.find_all_by_user_id_and_resource_type(self.id, resource_class)',
       :hash_name=>'personal_resources_policies_hash'
      }    
      @admin.personal_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      @admin.personal_resources_policies_hash_for_class_of(@ivanov)[:User].should have(2).item
      
      # group_resources_policies_hash_for_class_of(@ivanov)
      opt= {
       :finder=>'PersonalResourcePolicy.find_all_by_user_id_and_resource_type(self.id, resource_class)',
       :hash_name=>'personal_resources_policies_hash',
       :before_find=>'(@group_resources_policies_hash[resource_class.to_sym]= result_hash and return @group_resources_policies_hash) unless self.role'
      }
      @admin.group_resources_policies_hash_for_class_of(@ivanov).should have(1).item
      @admin.group_resources_policies_hash_for_class_of(@ivanov)[:User].should have(2).item
    end
    
end
