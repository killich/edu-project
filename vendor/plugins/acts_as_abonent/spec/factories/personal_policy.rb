# Создал фабрику для персональной политики (PersonalPolicy)
Factory.define :personal_policy do |pp| end

###################################################################################################
# Персональная политика
###################################################################################################

# Персональная политика для данного пользователя
Factory.define  :page_manager_personal_policy, :class => PersonalPolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 3.days)
  r.counter     5
  r.max_count   15
end

# Персональная политика для данного пользователя
Factory.define  :page_tree_personal_policy, :class => PersonalPolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 1.days)
  r.counter     2
  r.max_count   11
end

# Персональная политика для данного пользователя
Factory.define  :page_tree_personal_policy_unlimited, :class => PersonalPolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
end

Factory.define  :page_manager_personal_policy_unlimited, :class => PersonalPolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
end