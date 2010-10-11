class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|

      # Анкета пользователя
      t.integer   :user_id          # Кому принадлежит
      t.string    :zip              # zip id анкеты
      t.date      :birthday         # День рождения
      t.string    :native_town      # Родной город
      
      # Контактные данные
      t.string    :home_phone       # Домашний телефон
      t.string    :cell_phone       # Мобильный телефон
      t.string    :icq              # icq
      t.string    :jabber           # jabber
      t.string    :public_email     # публичный email
      t.string    :web_site         # web сайт

      # Личные данные
      t.text    :activity         # Деятельность
      t.text    :interests        # Интересы
      t.text    :music            # музыка
      t.text    :movies           # Фильмы
      t.text    :tv               # тв
      t.text    :books            # книги
      t.text    :citation         # цитаты
      t.text    :about_myself     # о себе
      
      # Где я сейчас учусь
      t.string    :study_town         # город
      t.string    :study_place        # место
      t.string    :study_status       # статус
      
      # Где я сейчас работаю
      t.string    :work_town         # город
      t.string    :work_place        # место
      t.string    :work_status       # статус (должность)
      
      t.text      :settings          # Набор различных настроек анкеты
      
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
