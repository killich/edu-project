# Данные по умолчанию для сайта
namespace :db do
  # rake db:basic_data
  desc 'create basic data'
  
  task :basic_data => ['db:drop', 'db:create', 'db:migrate', 'db:roles:create', 'db:users:create', 'db:pages:create', 'storage:add'] # , 'db:import:start', 'db:import:asks'
  # rake paperclip:refresh CLASS='StorageFile'
      
  # Раздел создания базовых пользователей системы
  namespace :users do
    # rake db:users:create
    desc 'create basic users'
    task :create => :environment do
    
      require "#{RAILS_ROOT}/spec/factories/users"
      require "#{RAILS_ROOT}/spec/factories/profile"
    
      # Создать администратора
      user= Factory.create(:user,
        :login => 'portal',
        :email => 'iv-schools@yandex.ru',
        :crypted_password=>'1111111111',
        :salt=>'salt',
        :name=>'Зыкин Илья Николаевич',
        :role_id=>Role.find_by_name('administrator').id
      )
      profile= Factory.create(:empty_profile, :user_id => user.id)
      
      #--------------------------------------------------------------
      ss= StorageSection.new(:user_id=>user.id, :title=>'Основное')
      ss.save!
      #--------------------------------------------------------------
      
      #-------------------------------------------------------------------------------------------------------
      # ~Администратор портала
      #-------------------------------------------------------------------------------------------------------
      
      logins= {
        :iv36=>'1111111111',
        :iv43=>'1111111111',
        :kohma5=>'1111111111',
        :kohma6=>'1111111111',
        :kohma7=>'1111111111',
        :kohma5vecher=>'1111111111'
      }

      logins.each_pair do |login, pwd|
        user= Factory.create(:user,
          :login => "#{login.to_s}",
          :email => "#{login.to_s}@iv-schools.ru",
          :crypted_password=>"#{pwd}",
          :salt=>'salt',
          :name=>"Администратор",
          :role_id=>Role.find_by_name('site_administrator').id
        )
        profile= Factory.create(:empty_profile, :user_id => user.id)
      end#logins.each
      
      # Администраторы страниц портала
      logins= {}#%w{ moderator001 moderator002 moderator003 } 
      logins.each do |login|
        user= Factory.create(:user,
          :login => "#{login.to_s}",
          :email => "#{login.to_s}@iv-schools.ru",
          :crypted_password=>"#{login}",
          :salt=>'salt',
          :name=>"Модератор",
          :role_id=>Role.find_by_name('page_administrator').id
        )
        profile= Factory.create(:empty_profile, :user_id => user.id)
      end#logins.each
      
    end# db:users:create
  end#:users
end#:db