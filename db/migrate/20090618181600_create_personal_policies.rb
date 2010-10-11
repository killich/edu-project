class CreatePersonalPolicies < ActiveRecord::Migration
# PersonalPolicy - обеспечивает назначение права доступа некоторого пользователя на исполнение некоторой функции
# Привязанно к конкретному пользователю
# Обеспечивает временнОе и количественное ограничение использования заданной функции
# -Обеспечивает доступ персоны к группе (целому классу) объектов
# (Пользователь может редактировать все деревья страниц проекта с ограничением по времени и кол-ву фактов доступа к функции)
# id | user_id | section | action | value | start_at | finish_at | counter | max_count

  def self.up
    create_table :personal_policies do |t|
      t.integer   :user_id
      
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
    drop_table :personal_policies
  end
end
