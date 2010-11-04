# Сбросить все пароли пользователей
namespace :db do
  namespace :reset do
  
    # rake db:reset:passwords
    desc 'reset passwords to qwerty'
    task :passwords => :environment do
    
    User.find(:all).each do |user|
      user.crypted_password = 'qwerty'
      user.save!
    end
 
    end# rake db:reset:passwords
  end#:reset
end#:db