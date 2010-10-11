module Killich #:nodoc:
  module Acts #:nodoc:
    module Abonent #:nodoc:
      def self.included(base)
        base.extend(SingletonMethods)
      end
      
      module SingletonMethods
        def acts_as_abonent
          class_eval "belongs_to :role"
          include AbonentMethods
        end# acts_as_abonent
      end# SingletonMethods
      
      module AbonentMethods
      
        #belongs_to :role
        def set_role(role)
          return unless role
          return false unless role.is_a?(Role)
          self.role_id= role.id
        end
        
        #belongs_to :role
        def update_role(role)
          return false unless role
          return false unless role.is_a?(Role)
          self.update_attribute(:role, role) and return true
        end
  
        # Ролевая политика (Наиболее общая)
        def role_policies_hash
          @role_policies_hash ||= (self.role ? (self.role.settings.is_a?(String) ? YAML::load(self.role.settings) : Hash.new) : Hash.new )
        end
        
        # interfaces
        def has_role_policy?(section, policy)
          return false unless role_policies_hash[section.to_sym] && role_policies_hash[section.to_sym][policy.to_sym]
          role_policies_hash[section.to_sym][policy.to_sym]
        end
        
        def is_owner_of?(obj)
          return false unless obj
          return false unless (obj.class.superclass == ActiveRecord::Base)
          return self.id == obj.id          if obj.is_a?(User)
          return self.id == obj[:user_id]   if obj[:user_id]
          return self.id == obj[:user][:id] if obj[:user]
          false
        end

        # Базовые функции проверки актаульности
        def policy_actual_by_counter?(counter, max_count)
          return true unless max_count && counter
          counter <= max_count
        end

        def policy_actual_by_time?(start_at, finish_at)
          return true if (!start_at && !finish_at)
          now= DateTime.now
          return (finish_at.to_datetime >= now) unless start_at
          return (start_at.to_datetime  <= now) unless finish_at
          start_at.to_datetime <= now && now <= finish_at.to_datetime
        end

        # Базовые функции работы со счетчиком
        def counter_should_be_updated?(policy_hash)
          return false unless policy_hash.is_a?(Hash)
          return false unless policy_hash[:counter] && policy_hash[:max_count]
          policy_hash[:counter] <= policy_hash[:max_count]
        end
        
        def update_policy_counter(options = {}) 
          opts = {
            :update_table=>false,
            :updated_policy=>false,
            :counter_increment=>1
          }.merge!(options)
          return if opts[:counter_increment].nil? || opts[:counter_increment] == 0
          return if !opts[:update_table] || !opts[:updated_policy]
          return unless opts[:updated_policy].is_a?(Hash)
          return unless opts[:updated_policy][:id]
          # opts[:update_table].constantize.send(:update_counters, opts[:updated_policy][:id], :counter => opts[:counter_increment])
          eval("#{opts[:update_table]}.update_counters(#{opts[:updated_policy][:id]}, :counter=>#{opts[:counter_increment]})")
          opts[:updated_policy][:counter]= opts[:updated_policy][:counter]+opts[:counter_increment]
        end
        
        # Базовые функции проверки доступа/блокировки
        def create_policy_hash(options = {})
          opts = {
            :hash_name =>   false,
            :before_find => false,
            :finder =>      false, 
            :recalculate => false
          }.merge!(options)
          instance_variable_set("@#{opts[:hash_name]}", nil) if opts[:recalculate]
          return if instance_variable_get("@#{opts[:hash_name]}")
          result_hash= Hash.new
          instance_variable_set("@#{opts[:hash_name]}", result_hash)
          return unless (opts[:finder] || opts[:hash_name])
          eval(opts[:before_find]) if opts[:before_find]
          eval(opts[:finder]).each do |policy_hash|
            _policy_hash={
              policy_hash.policy.to_sym=>{
                :id=>policy_hash.id,
                :value=>policy_hash.value,
                :start_at=>policy_hash.start_at,
                :finish_at=>policy_hash.finish_at,
                :counter=>policy_hash.counter,
                :max_count=>policy_hash.max_count
              }
            }
            if result_hash.has_key?(policy_hash.section.to_sym)
              result_hash[policy_hash.section.to_sym].merge!(_policy_hash)
            else
              _hash={ policy_hash.section.to_sym => _policy_hash }        
              result_hash.merge!(_hash)                              
            end
          end
          instance_variable_set("@#{opts[:hash_name]}", result_hash)
          return
        end
        
        def get_policy_hash(section, policy, hash_name, options = {})
          opts = {
            :recalculate => false
          }.merge!(options)
          send("create_#{hash_name}", opts)
          return nil if !instance_variable_get("@#{opts[:hash_name]}").values_at(section.to_sym) || !instance_variable_get("@#{opts[:hash_name]}").values_at(section.to_sym).first
          section_of_policies_hash= instance_variable_get("@#{opts[:hash_name]}").values_at(section.to_sym).first
          return nil if !section_of_policies_hash.values_at(policy.to_sym) || !section_of_policies_hash.values_at(policy.to_sym).first
          section_of_policies_hash.values_at(policy.to_sym).first
        end
                
        def check_policy(section, policy, hash_name, options = {})
          opts = {
            :recalculate => false,
            :return_invert=>false,
            :policy_table=>false
          }.merge!(options)
          policy_hash= get_policy_hash(section, policy, hash_name, opts)
          return false unless policy_hash
          value= opts[:return_invert] ? !policy_hash[:value] : policy_hash[:value]
          time_check=     policy_actual_by_time?(policy_hash[:start_at], policy_hash[:finish_at])
          counter_check=  policy_actual_by_counter?(policy_hash[:counter], policy_hash[:max_count])
          update_opts={ :update_table=>opts[:update_table], :updated_policy=>policy_hash}
          update_opts[:counter_increment]= opts[:counter_increment] if opts[:counter_increment]
          update_policy_counter(update_opts) if counter_should_be_updated?(policy_hash) && time_check
          return value if counter_check && time_check
          false
        end
        
        def policy_exists(section, policy, hash_name, options = {})
          get_policy_hash(section, policy, hash_name, options).is_a?(Hash)
        end
        
        # Персональная политика
        def create_personal_policies_hash(options = {})
          opts= {
            :hash_name=>'personal_policies_hash',
            :finder=>'PersonalPolicy.find_all_by_user_id(self.id)'
          }
          create_policy_hash options.merge!(opts)
          @personal_policies_hash
        end
        
        # interfaces
        def personal_policy_exists?(section, policy, options = {})
          policy_exists(section, policy, 'personal_policies_hash', options)
        end
        
        def get_personal_policy_hash(section, policy, options = {})
          get_policy_hash(section, policy, 'personal_policies_hash', options)
        end
        
        def has_personal_access?(section, policy, options = {})
          opts={ :update_table=>'PersonalPolicy' }
          check_policy(section, policy, 'personal_policies_hash', options.merge!(opts))
        end

        def has_personal_block?(section, policy, options = {})
          opts={ :update_table=>'PersonalPolicy', :return_invert=>true }
          check_policy(section, policy, 'personal_policies_hash', options.merge!(opts))
        end

        # Групповая политика
        def create_group_policies_hash(options = {})
          opts= {
            :hash_name=>'group_policies_hash',
            :before_find=>'return unless self.role',
            :finder=>'GroupPolicy.find_all_by_role_id(self.role.id)'
          }
          create_policy_hash options.merge!(opts)
          @group_policies_hash
        end
        
        # interfaces
        def group_policy_exists?(section, policy, options = {})
          policy_exists(section, policy, 'group_policies_hash', options)
        end
        
        def get_group_policy_hash(section, policy, options = {})
          get_policy_hash(section, policy, 'group_policies_hash', options)
        end
        
        def has_group_access?(section, policy, options = {})
          opts={ :update_table=>'GroupPolicy' }
          check_policy(section, policy, 'group_policies_hash', options.merge!(opts))
        end

        def has_group_block?(section, policy, options = {})
          opts={ :update_table=>'GroupPolicy', :return_invert=>true }
          check_policy(section, policy, 'group_policies_hash', options.merge!(opts))
        end

        # Общие функции ресурсной политики
        def create_resources_policies_hash_for_class_of(resource, options = {})
          opts = {
            :hash_name =>   false,
            :before_find => false,
            :finder =>      false
          }.merge!(options)
          resource_class=  resource.class.to_s
          result_hash= Hash.new          
          instance_variable_set("@#{opts[:hash_name]}", nil) if (instance_variable_get("@#{opts[:hash_name]}") && opts[:reset])
          instance_variable_get("@#{opts[:hash_name]}")[resource_class.to_sym]= nil if (instance_variable_get("@#{opts[:hash_name]}") && instance_variable_get("@#{opts[:hash_name]}")[resource_class.to_sym] && opts[:recalculate])
          instance_variable_set("@#{opts[:hash_name]}", Hash.new) unless instance_variable_get("@#{opts[:hash_name]}")
          return if instance_variable_get("@#{opts[:hash_name]}")[resource_class.to_sym]
          return unless (opts[:finder] || opts[:hash_name])
          eval(opts[:before_find]) if opts[:before_find]    
          eval(opts[:finder]).each do |policy_hash|
              result_hash[policy_hash.resource_id]= {
                policy_hash.section.to_sym=>{
                  policy_hash.policy.to_sym=>{
                    :id=>policy_hash.id,
                    :value=>policy_hash.value,
                    :start_at=>policy_hash.start_at,
                    :finish_at=>policy_hash.finish_at,
                    :counter=>policy_hash.counter,
                    :max_count=>policy_hash.max_count
                  }
                } 
              }
          end
          instance_variable_get("@#{opts[:hash_name]}")[resource_class.to_sym]= result_hash
          return
        end
        
        def get_resource_policy_hash(object, section, policy, hash_name, options = {})
          opts = {
            :recalculate => false,
            :reset => false
          }.merge!(options)
          send("#{hash_name}_for_class_of", object, opts)
          return nil if     instance_variable_get("@#{opts[:hash_name]}")[object.class.to_s.to_sym].empty?
          return nil unless instance_variable_get("@#{opts[:hash_name]}")[object.class.to_s.to_sym][object.id]
          return nil unless instance_variable_get("@#{opts[:hash_name]}")[object.class.to_s.to_sym][object.id][section.to_sym]
          return nil unless instance_variable_get("@#{opts[:hash_name]}")[object.class.to_s.to_sym][object.id][section.to_sym][policy.to_sym]
          instance_variable_get("@#{opts[:hash_name]}")[object.class.to_s.to_sym][object.id][section.to_sym][policy.to_sym]
        end
        
        def check_resource_policy(object, section, policy, hash_name, options = {})
          opts = {
            :recalculate => false,
            :reset => false,
            :return_invert=>false
          }.merge!(options)
          policy_hash= get_resource_policy_hash(object, section, policy, hash_name, opts)
          return false unless policy_hash
          value= opts[:return_invert] ? !policy_hash[:value] : policy_hash[:value]
          time_check=     policy_actual_by_time?(policy_hash[:start_at], policy_hash[:finish_at])
          counter_check=  policy_actual_by_counter?(policy_hash[:counter], policy_hash[:max_count])
          update_opts={ :update_table=>opts[:update_table], :updated_policy=>policy_hash}
          update_opts[:counter_increment]= opts[:counter_increment] if opts[:counter_increment]
          update_policy_counter(update_opts) if counter_should_be_updated?(policy_hash) && time_check
          return value if counter_check && time_check
          false
        end

        def resource_policy_exists(object, section, policy, hash_name, options = {})
          get_resource_policy_hash(object, section, policy, hash_name, options).is_a?(Hash)
        end

        # Персональная политика к ресурсу
        def personal_resources_policies_hash_for_class_of(resource, options = {})
          opts= {
           :hash_name=>'personal_resources_policies_hash',
           :finder=>'PersonalResourcePolicy.find_all_by_user_id_and_resource_type(self.id, resource_class)'
          }
          create_resources_policies_hash_for_class_of(resource, options.merge!(opts))
          @personal_resources_policies_hash
        end
        
        # interfaces
        def personal_resource_policy_exists?(object, section, policy, options = {})
          resource_policy_exists(object, section, policy, 'personal_resources_policies_hash', options)
        end
        
        def get_personal_resource_policy_hash(object, section, policy, options = {})
          get_resource_policy_hash(object, section, policy, 'personal_resources_policies_hash', options)
        end
        
        def has_personal_resource_access_for?(object, section, policy, options = {})
          opts={ :update_table=>'PersonalResourcePolicy' }
          check_resource_policy(object, section, policy, 'personal_resources_policies_hash', options.merge!(opts))
        end
        
        def has_personal_resource_block_for?(object, section, policy, options = {})
          opts={ :update_table=>'PersonalResourcePolicy', :return_invert=>true }
          check_resource_policy(object, section, policy, 'personal_resources_policies_hash', options.merge!(opts))
        end

        # Групповая политика к ресурсу
        def group_resources_policies_hash_for_class_of(resource, options = {})
          opts= {
           :hash_name=>'group_resources_policies_hash',
           :before_find=>'@group_resources_policies_hash[resource_class.to_sym]= result_hash and return unless self.role',
           :finder=>'GroupResourcePolicy.find_all_by_role_id_and_resource_type(self.role.id, resource_class)'
          }
          create_resources_policies_hash_for_class_of(resource, options.merge!(opts))
          @group_resources_policies_hash
        end
        
        # interfaces
        def group_resource_policy_exists?(object, section, policy, options = {})
          resource_policy_exists(object, section, policy, 'group_resources_policies_hash', options)
        end
        
        def get_group_resource_policy_hash(object, section, policy, options = {})
          get_resource_policy_hash(object, section, policy, 'group_resources_policies_hash', options)
        end
        
        def has_group_resource_access_for?(object, section, policy, options = {})
          opts={ :update_table=>'GroupResourcePolicy' }
          check_resource_policy(object, section, policy, 'group_resources_policies_hash', options.merge!(opts))
        end
        
        def has_group_resource_block_for?(object, section, policy, options = {})
          opts={ :update_table=>'GroupResourcePolicy', :return_invert=>true }
          check_resource_policy(object, section, policy, 'group_resources_policies_hash', options.merge!(opts))
        end
        
        # hi level interfaces
        def has_complex_block?(section, policy, options = {})
          return true if self.has_personal_block?(section, policy, options)
          return true if self.has_group_block?(section, policy, options)
          false
        end
        
        def has_complex_access?(section, policy, options = {})
          return true if self.has_personal_access?(section, policy, options)
          return true if self.has_group_access?(section, policy, options)
          false
        end
        
        def has_complex_resource_block_for?(object, section, policy, options = {})
          return true if self.has_personal_resource_block_for?(object, section, policy, options)
          return true if self.has_group_resource_block_for?(object, section, policy, options)
          false
        end
        
        def has_complex_resource_access_for?(object, section, policy, options = {})
          return true if self.has_personal_resource_access_for?(object, section, policy, options)
          return true if self.has_group_resource_access_for?(object, section, policy, options)
          false
        end
        
        def has_policy_complex_check?(section, policy, options = {})
          return true if personal_policy_exists?(section, policy, options)
          return true if group_policy_exists?(section, policy, options)
          return true if has_role_policy?(section, policy)
          false
        end
        
      end# AbonentMethods
    end# Abonent
  end# Acts
end# Killich