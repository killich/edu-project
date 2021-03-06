class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :user_id  # Владелец страницы
      # Специальный маркер, идентифицирующий страницу.
      # Например к любой странице можно будет обращаться
      # site.com/pages/1347-2346-2231
      # 999.999.999.999 комбинаций, т.е. 555.555.555.555 комбинаций могут быть
      # использованы без существенных проблем с генерацией нового случайного zip
      # Что должно существенно упростить адресацию при диктовке адреса по телефону, например
      # Предполагается использовать для большинства объектов системы
      t.string  :zip

      # Мета информация
      t.string :author      # Автор страницы
      t.string :keywords    # Ключевые слова страницы
      t.string :description # Описание страницы
      t.string :copyright   # Авторское право

      # Заголовок страницы
      t.string :title
      # Аннотация (от лат. annotatio — замечание) — краткая характеристика издания: рукописи, статьи или книги.
      # Это то, что называют кат'ом (cut), но в более научной и строгой форме
      t.text   :annotation
      # Содержимое страницы
      t.text   :content
      # Предподготовленный безопасный контент
      t.text   :prepared_content
      
      # Набор различных настроек :: сериализованные данные :: YAML :: должен быть организован единый интерфейс
      t.text    :settings
      # Отображение страницы show (открыта), hide(скрыта), closed(закрыта), protected(управляется другими настройками)
      t.string  :state, :default=>'hidden'
      
      # Поведение дерева (вложенные массивы - nested sets)
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
            
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
