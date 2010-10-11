class CreateGroupResourcePolicies < ActiveRecord::Migration
# GroupResourcePolicy - обеспечивает доступ группы пользователей к выполнению функции по отношению к некоторому объекту
# Полиморфная модель
# (Группа пользователей может редактировать центральное дерево страниц и никакое иное с ограничением по времени и кол-ву фактов доступа к функции)
# Привязано к конкретной роли (группе)
# -Обеспечивает доступ группы к конкретному объекту
# id | role_id | recource_id | recource_type | section | action | value | start_at | finish_at | counter | max_count

  def self.up
    create_table :group_resource_policies do |t|
      t.integer   :role_id
      
      t.integer   :resource_id
      t.string    :resource_type
      
      t.string    :section
      t.string    :policy
      t.boolean   :value
      
      t.datetime  :start_at
      t.datetime  :finish_at
      
      t.integer   :counter
      t.integer   :max_count
      
      t.timestamps
    end
  end

  def self.down
    drop_table :group_resource_policies
  end
end
