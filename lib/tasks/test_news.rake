# Данные по умолчанию для сайта
namespace :db do
  # rake db:create:test_news
  desc 'create test news'
  namespace :create do
  
    # rake db:users:create
    desc 'create test news'
    task :test_news => :environment do
      users = User.find(:all)
      users.each do |user|
        10.times do
          report = user.reports.new(
            :title=>Faker::Lorem.sentence(3),
            :description=>Faker::Lorem.sentence(15),
            :content=>Faker::Lorem.sentence(30)
          )
          report.save!
          # Сделать дочерних страниц
          if [true, false].rand
            (1..8).to_a.rand.times do
              # Сделать дочернюю новость
              report_child = user.reports.new(
                :title=>Faker::Lorem.sentence(3),
                :description=>Faker::Lorem.sentence(15),
                :content=>Faker::Lorem.sentence(30)
              )
              report_child.save!
              # Сделать дочернюю, дочерью корневой страницы
              report_child.move_to_child_of(report)
              
              # Сделать дочерних страниц
              if [true, false].rand
                (4..12).to_a.rand.times do
                  # Сделать дочернюю новость
                  report_child2 = user.reports.new(
                    :title=>Faker::Lorem.sentence(3),
                    :description=>Faker::Lorem.sentence(15),
                    :content=>Faker::Lorem.sentence(30)
                  )
                  report_child2.save!
                  # Сделать дочернюю, дочерью корневой страницы
                  report_child2.move_to_child_of(report_child)
                end# 15.times
              end# if [true, false]
              
            end# (1..8).to_a.rand.times
          end# if [true, false]
        end# 10.times
      end# users.each
    end# rake db:create:test_news
    
  end#:create
end#:db