# Уходит в папку lib данного плагина - находит там acts_as_abonent.rb
require 'acts_as_abonent'

# Дополняет ActiveRecord доп. определениями
# Но поскольку нужно дополнить функционалом только модель User
# acts_as_abonent.rb дополняет каждую модель ActiveRecord только SingletonMethods::acts_as_abonent

# функция acts_as_abonent, будучи вызванной в модели User
# Выполняет include модуля include Killich::Acts::Abonent::AbonentMethods
# Тем самым наделяя модель User функциями абонента
ActiveRecord::Base.class_eval do
  include Killich::Acts::Abonent
end

