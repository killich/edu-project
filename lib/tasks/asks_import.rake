# Вопросы пользователей 
namespace :db do
  namespace :import do
    # rake db:import:asks
    desc 'import ASK data form ivschools'
    task :asks => :environment do
    
      # Класс подключения к БД      
      class IvSchoolsConnect< ActiveRecord::Base
          establish_connection(
	        :old_iv_schools
          )
      end
    
      require 'php_serialize'
      require 'iconv'
      $KCODE='u'

      logins= %w{ iv36 iv43 kohma5 kohma6 kohma7 kohma5vecher }
      logins.each do |login|
        
        # Выбрать данного пользователя
        u= User.find_by_login(login)
        p 'User is: ' + u.login + ' and Id = ' + u.id.to_s
        
        # Получить записи таблицы из базы PHP
        eval("
          class IvSchoolsAskSection < IvSchoolsConnect
              set_table_name '#{login}_pub_msg'
          end
        ")
        asks= IvSchoolsAskSection.find(:all)
        
        # Перебрать все записи
        asks.each do |ask|
          # ask.Content - переконвертировать
          ask_data= Iconv.new("cp1251//IGNORE", "UTF-8").iconv(ask.Content)      
          ask_data= PHP.unserialize(ask_data)
          
          cp2utf= Iconv.new("UTF-8//IGNORE", "cp1251")
          
          u.questions.new(
                          :from=>cp2utf.iconv(ask_data['from']),                          
                          :to=>cp2utf.iconv(ask_data['to']),
                          :topic=>cp2utf.iconv(ask_data['topic']),
                          :question=>cp2utf.iconv(ask_data['ask']),
                          :answere=>cp2utf.iconv(ask_data['ans'])
          ).save!
          # Создать вопрос для данного пользователя
          #PHP.unserialize(ask_data).each do |n, v|
        end#asks.each
        
      end#logins
      
    end#task :asks
  end#:import
end#:db