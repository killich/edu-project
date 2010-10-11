# Базовые роли пользователей
namespace :db do
  namespace :roles do
  
    # rake db:roles:create
    desc 'create basic roles for project'
    task :create => :environment do
    
      require "#{RAILS_ROOT}/spec/factories/role"
    
      Factory.create(:registrated_user_role)
      Factory.create(:guaranted_user_role)
      Factory.create(:site_administrator_role)
      Factory.create(:page_administrator_role)
      Factory.create(:administrator_role)
      
    end# rake db:roles:create
  end#:roles
end#:db