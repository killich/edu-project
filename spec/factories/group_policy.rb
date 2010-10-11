# Создал фабрику для Надстройки для групповой политики (GroupPolicy)
Factory.define :group_policy do |gp| end                  

###################################################################################################
# Групповая политика
###################################################################################################

# Политика для данной группы
Factory.define  :page_manager_group_policy, :class => GroupPolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 3.days)
  r.counter     5
  r.max_count   15
end

# Политика для данной группы
Factory.define  :page_tree_group_policy, :class => GroupPolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
  r.start_at    DateTime.now
  r.finish_at(  DateTime.now + 1.days)
  r.counter     2
  r.max_count   11
end

Factory.define  :page_tree_group_policy_unlimited, :class => GroupPolicy do |r|
  r.section     'pages'
  r.policy      'tree'
  r.value       true
end

Factory.define  :page_manager_group_policy_unlimited, :class => GroupPolicy do |r|
  r.section     'pages'
  r.policy      'manager'
  r.value       true
end