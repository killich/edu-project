class CreateGroupPolicies < ActiveRecord::Migration

# GroupPolicy - надстройка над Моделью Role, обеспечивающая граничение по времени и количеству фактов доступа к функции
# Привязано к конкретной роли.
# -Обеспечивает доступ группы к классу объектов
# (Группа пользователей может редактировать все деревья страниц проекта с ограничением по времени и колву фактов доступа)
# id | role_id | section | action | value | start_at | finish_at | counter | max_count
# Для конкретного пользователя sql запросом для данной роли выбирается весь массив настроек
# формируется хеш массив, при необходимости проверки - сопостовляется и проверяется по времени, количеству фактов доступа
# при необходимости, выполняется инкрементация счетчика в БД на заданное кол-во единиц
# Интегрировано в интерфейс редактирования модели Role

  def self.up
    create_table :group_policies do |t|
      t.integer   :role_id
      
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
    drop_table :group_policies
  end
end
