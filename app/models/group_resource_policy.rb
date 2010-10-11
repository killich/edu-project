class GroupResourcePolicy < ActiveRecord::Base
# GroupResourcePolicy - обеспечивает доступ группы пользователей к выполнению функции по отношению к некоторому объекту
# Полиморфная модель
# (Группа пользователей может редактировать центральное дерево страниц и никакое иное с ограничением по времени и кол-ву фактов доступа к функции)
# Привязано к конкретной роли (группе)
# -Обеспечивает доступ группы к конкретному объекту
# id | role_id | recource_id | recource_type | section | action | value | start_at | finish_at | counter | max_count

  belongs_to :role
  belongs_to :resource, :polymorphic =>true
end
