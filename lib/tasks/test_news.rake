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
          user.reports.new(
            :title=>'test',
            :description=>'test',
            :content=>'test'
          ).save!
        end# 10.times
      end# users.each
    end# rake db:create:test_news
    
  end#:create
end#:db