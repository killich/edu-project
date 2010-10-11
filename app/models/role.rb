class Role < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :title
  validates_presence_of :description  # Описание должно быть более 30 символов

  has_many :users                     # Роль связана с многими пользователями
  has_many :group_policies            # Со многими дополнительными политиками для данной роли и ограничениями по времени и кол-ву фактов доступа
  has_many :group_resource_policies   # Со многими связями по доступу к ресурсам
end
