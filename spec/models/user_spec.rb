require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do  
  describe 'PersonalResourcePolicy' do
    before(:each) do
      create_users
    end

    def create_users
      @admin= Factory.create(:admin)
      @ivanov= Factory.create(:ivanov)
      @petrov= Factory.create(:petrov)
    end

    def admin_has_ivanov_as_resource
      @resource_ivanov=Factory.create(:page_manager_personal_resource_policy, :user_id=>@admin.id)
      @resource_ivanov.resource= @ivanov
      @resource_ivanov.save
    end    
    
    # Работа полиморфизма
    it '17:23 16.07.2009' do
      admin_has_ivanov_as_resource
      @resource_ivanov.resource_type.should == @ivanov.class.to_s
      @resource_ivanov.resource_id.should   == @ivanov.id
    end
        
    # policy_actual_by_counter?(counter, max_count)
    it '11:32 19.07.2009' do
      @admin.policy_actual_by_counter?(false, false).should be_true
      @admin.policy_actual_by_counter?(nil, nil).should be_true
      
      @admin.policy_actual_by_counter?(nil, 17).should  be_true
      @admin.policy_actual_by_counter?(17, nil).should  be_true
      
      @admin.policy_actual_by_counter?(-5, 17).should   be_true
      @admin.policy_actual_by_counter?(16, 17).should   be_true
      @admin.policy_actual_by_counter?(17, 17).should   be_true
      
      @admin.policy_actual_by_counter?(-7, -5).should   be_true
      @admin.policy_actual_by_counter?(-5, -5).should   be_true
      @admin.policy_actual_by_counter?(17, -17).should  be_false      
    end
    
    # policy_actual_by_time?(start_at, finish_at)
    it '11:48 19.07.2009' do
      @admin.policy_actual_by_time?(nil, nil).should  be_true                                       # нет ограничений
      
      @admin.policy_actual_by_time?(DateTime.now-1.second, nil).should  be_true                     # уже началось
      @admin.policy_actual_by_time?(DateTime.now-1.second, DateTime.now+1.second).should  be_true   # еще не закончилось      
      @admin.policy_actual_by_time?(nil, DateTime.now+1.second).should  be_true                     # еще не закончилось
      @admin.policy_actual_by_time?(nil, DateTime.now-1.second).should  be_false                    # уже закончилось

      @admin.policy_actual_by_time?(DateTime.now-2.second, DateTime.now-1.second).should  be_false  # уже закончилось
      @admin.policy_actual_by_time?(DateTime.now+1.second, DateTime.now+2.second).should  be_false  # еще не началось
      @admin.policy_actual_by_time?(DateTime.now+1.second, nil).should  be_false                    # еще не началось

      # Error
      @admin.policy_actual_by_time?(DateTime.now+1.second, DateTime.now-1.second).should  be_false
      @admin.policy_actual_by_time?(DateTime.now+2.second, DateTime.now+1.second).should  be_false
      @admin.policy_actual_by_time?(DateTime.now-1.second, DateTime.now-2.second).should  be_false
    end
    
    # У пользователя есть профайл и они друг с другом связаны
    it '23:12 22.07.2009' do
      profile= Factory.create(:empty_profile, :user_id=>@admin.id)
      @admin.profile.should  be_instance_of(Profile)
      profile.user.should  be_instance_of(User)
    end
    
    # Создание пользователя, назначение проли, создание профайла
    it '15:00 23.07.2009' do
      Factory.create(:registrated_user_role)
      valid_attributes= {
       'login'=>'qwerty',
       'password'=>'qwerty',
       'password_confirmation'=>'qwerty',
       'email'=>'qwerty@qwerty.ru'
      }
      user = User.new(valid_attributes)
      user.set_role(Role.find_by_name('registrated_user'))
      user.save.should be_true
      
      user.role_id.should be_instance_of(Fixnum)
      user.role.should be_instance_of(Role)
      
      Profile.new(:user_id=>user.id).save.should be_true
      user.profile.should be_instance_of(Profile)
    end
    
  end#PersonalResourcePolicy
end