class PersonalResourcePolicy < ActiveRecord::Base
# PersonalResourcePolicy - обеспечивает доступ пользователя к выполнению функции по отношению к некоторому объекту
# Полиморфная модель
# (Пользователь может редактировать центральное дерево страниц и никакое иное с ограничением по времени и кол-ву фактов доступа к функции)
# Привязано к конкретному пользователю
# -Обеспечивает доступ пользователя к конкретному объекту
# id | user_id | recource_id | recource_type | section | action | value | start_at | finish_at | counter | max_count

  belongs_to :user
  belongs_to :resource, :polymorphic =>true
end
