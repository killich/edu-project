# Создал фабрику для персональной политики для объекта (PersonalResourcePolicy)
Factory.define :personal_resource_policy do |prp| end 
  
###################################################################################################
# Персональная политика к ресурсу
###################################################################################################

# Политика для данного пользователя
Factory.define  :page_manager_personal_resource_policy, :class => PersonalResourcePolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 3.days)
  r.counter     5
  r.max_count   15
end

# Политика для данного пользователя
Factory.define  :page_tree_personal_resource_policy, :class => PersonalResourcePolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 1.days)
  r.counter     2
  r.max_count   11
end

# Политика для данного пользователя
Factory.define  :profile_edit_personal_resource_policy, :class => PersonalResourcePolicy do |r|
  r.section     'profile'
  r.policy      'edit'
  r.value       true
  r.start_at    DateTime.now-1.day
  r.finish_at   DateTime.now + 1.days
  r.counter     2
  r.max_count   11
end

# Персональная политика для данного пользователя
Factory.define  :page_tree_personal_resource_policy_unlimited, :class => PersonalResourcePolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
end

Factory.define  :page_manager_personal_resource_policy_unlimited, :class => PersonalResourcePolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
end