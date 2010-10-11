# Данные по умолчанию для сайта
namespace :db do
  namespace :pages do
    desc 'create test pages for users'
    # rake db:pages:create
    task :create => :environment do
      # Найти всех пользователей
      users= User.find(:all)
      
      # Для каждого пользователя
      users.each do |u|
        # 10 раз сделать страницу
        10.times do
          # Создать страницу
          page= u.pages.new(
            :author=>Faker::Name.name,
            :keywords=>Faker::Lorem.sentence(2),
            :description=>Faker::Lorem.sentence(2),
            :copyright=>Faker::Name.name,
            :title=>"#{u.login} : #{Faker::Lorem.sentence(3)}",
            :annotation=>Faker::Lorem.sentence(30),
            :content=>Faker::Lorem.paragraphs(50)
          )
          
          page.save # Сохранить страницу
          
=begin
          # C вероятностью 50/50, что будут созданы подстраницы для данной (дерево строю)
          if false #[true, false].rand
            # Пять раз
            5.times do
              # Создать дочернюю страницу
              child_page= u.pages.new(
                :author=>Faker::Name.name,
                :keywords=>Faker::Lorem.sentence(2),
                :description=>Faker::Lorem.sentence(2),
                :copyright=>Faker::Name.name,
                :title=>"Тестовая страница: #{Faker::Lorem.sentence}",
                :annotation=>Faker::Lorem.sentence(3),
                :content=>Faker::Lorem.paragraphs(50)
              )
              # Сохранить дочернюю страницу
              child_page.save
              # Дочернюю страницу сделать дочкой данной страницы
              child_page.move_to_child_of page

              # ТРЕТИЙ УРОВЕНЬ
                # C вероятностью 50/50, что будут созданы подстраницы для данной (дерево строю)
                if [true, false].rand
                  # Пять раз
                  5.times do
                    # Создать дочернюю страницу
                    level_child_page= u.pages.new(
                      :author=>Faker::Name.name,
                      :keywords=>Faker::Lorem.sentence(2),
                      :description=>Faker::Lorem.sentence(2),
                      :copyright=>Faker::Name.name,
                      :title=>"Тестовая страница: #{Faker::Lorem.sentence}",
                      :annotation=>Faker::Lorem.sentence(3),
                      :content=>Faker::Lorem.paragraphs(50)
                    )
                    # Сохранить дочернюю страницу
                    level_child_page.save
                    # Дочернюю страницу сделать дочкой данной страницы
                    level_child_page.move_to_child_of child_page
                  end# n.times do
                end# [true, false].rand
              # ТРЕТИЙ УРОВЕНЬ
              
            end# n.times do
          end# [true, false].rand
=end
          
        end# n.times do
      end# users.each do |u|
    end# db:pages:pages
    
  end#:pages
end#:db