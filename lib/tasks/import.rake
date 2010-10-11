# Базовые роли пользователей

namespace :db do
  namespace :import do
  
    # rake db:import:start
    desc 'import data form ivschools'
    task :start => :environment do
    
    def content_type(path)
      type = (path.match(/\.(\w+)$/)[1] rescue "octet-stream").downcase
      case type
      when %r"jpe?g"                 then "image/jpeg"
      when %r"tiff?"                 then "image/tiff"
      when %r"png", "gif", "bmp"     then "image/#{type}"
      when "txt"                     then "text/plain"
      when %r"html?"                 then "text/html"
      when "csv", "xml", "css", "js" then "text/#{type}"
      else "application/x-#{type}"
      end
    end
  
    class IvSchoolsPageConnect< ActiveRecord::Base
        establish_connection(
            :old_iv_schools
        )
    end
    
    require 'action_view/helpers/tag_helper'
    require 'action_view/helpers/url_helper'
    class Helpers
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
    end

    def file_div(files)
      help= Helpers.new
      res= ""
      files.each do |f|
        res+= ("\n\t"+help.content_tag(:li, help.link_to(f.Description, f.Path)))
      end
      res += "\n"
      res1 =  "\n\n"
      res1 =  help.content_tag(:ul, res, :class=>:linked_files)
      res1 +=  "\n\n"
      res1
    end
    
    def root_section_msg
      "
        <p>Уважаемый посетитель!</p>
        <p>
          В предыдущей версии информационной системы iv-schools.ru
          данная страница являлась корневой и не содержала существенной информации.
        </p>
        <p>
          Обратите внимание на боковую панель навигации, где, вероятно, Вы сможете обнаружить
          список вложенный страниц.
        </p>
        <p>
          Нам остается надеяться, что администратор данного подраздела вскоре наполнит данную страницу актуальной информацией.
        </p>
        <p>
          Для дальнейшей навигации вы можете использовать  <a href='/users'>список пользователей</a> и связанное с каждым пользователем системы дерево страниц (карту сайта).
        </p>
      "
    end
    
    logins= %w{ iv36 iv43 kohma5 kohma6 kohma7 kohma5vecher }
    
      logins.each do |login|
        user= User.find_by_login(login)

        ss= StorageSection.new(:user_id=>user.id, :name=>'Основное')
        ss.save!

        eval("
          class IvSchoolsSection < IvSchoolsPageConnect
              set_table_name '#{login}_Sections'
          end    
          class IvSchoolsPage < IvSchoolsPageConnect
              set_table_name '#{login}_Pages'
          end
          class IvSchoolsLinkedFiles < IvSchoolsPageConnect
              set_table_name '#{login}_Linked_Files'
          end
          class IvSchoolsCommonFiles < IvSchoolsPageConnect
              set_table_name '#{login}_Common_Files'
          end
        ")
        
        # Все прилинкованные файлы
        file_storage= IvSchoolsLinkedFiles.find(:all)
        # Все прилинкованные файлы перебрать и создать записи
        file_storage.each do |file|
          file_path= file.Path.dup
          file_path.gsub!("./files/#{login}/common/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          file_path.gsub!("./files/#{login}/pages/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          
          file_path.gsub!("./files/common/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          file_path.gsub!("./files/#{login}/pages/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          
          if File.exists?(file_path)
            new_file_record= StorageFile.new( :user_id=>user.id,
                                              :storage_section_id=>ss.id,
                                              :name=>file.Description,
                                              :file_file_name=>file.Path.split('/')[-1],
                                              :file_content_type=>content_type(file_path),
                                              :file_file_size=>File.size(file_path),
                                              :file_updated_at=>DateTime.now
                                            )
            new_file_record.save
          else
            puts file_path
          end
        end

        # Все общие файлы
        file_storage= IvSchoolsCommonFiles.find(:all)
        # Все общие файлы перебрать и создать записи
        file_storage.each do |file|
          file_path= file.Path.dup
          file_path.gsub!("./files/#{login}/common/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          file_path.gsub!("./files/#{login}/pages/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          
          file_path.gsub!("./files/common/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          file_path.gsub!("./files/#{login}/pages/", "#{RAILS_ROOT}/public/uploads/files/#{login}/original/")
          if File.exists?(file_path)
            new_file_record= StorageFile.new( :user_id=>user.id,
                                              :storage_section_id=>ss.id,
                                              :name=>file.Description,
                                              :file_file_name=>file.Path.split('/')[-1],
                                              :file_content_type=>content_type(file_path),
                                              :file_file_size=>File.size(file_path),
                                              :file_updated_at=>DateTime.now
                                            )
            new_file_record.save
          else
            puts file_path
          end
        end        
        
          
        #IvSchoolsPage.find:first
        sections= IvSchoolsSection.find(:all,  :order=>"Prev_Id ASC")
        ids_set= Hash.new
        
        sections.each do |s|
          # Старый id страницы
          old_id= s.Page_Id
          # Старая страница
          basic_page= IvSchoolsPage.find(old_id)
          
          # Найти файлы если они прикреплены к странице
          files= IvSchoolsLinkedFiles.find(:all, :conditions => ['Page_Id = ? and Linked = ?', old_id, 1])
          
          title= basic_page.Description.gsub("&gt;", '>').gsub("&lt;", '<').gsub("&quot;", "'")

          content= basic_page.Content.gsub("&gt;", '>').gsub("&lt;", '<').gsub("&quot;", "'")
          content.gsub!('<h1>Корневой раздел сайта</h1>', root_section_msg)
          content += file_div(files) unless files.empty?
          
          content.gsub!("./files/common/", "/uploads/files/#{login}/original/")
          content.gsub!("./files/pages/", "/uploads/files/#{login}/original/")
          content.gsub!("./files/pages/", "/uploads/files/#{login}/original/")
          
          # Такие блоки текста надо заменять на href="#" onclick="javascript:alert('после запуска новой версии сайта ссылка не действительна');return false;"
          #href="http://iv36.iv-schools.ru/index.php?action=show&page_id=69"
          
          content.gsub!("./files/#{login}/common/", "/uploads/files/#{login}/original/")
          content.gsub!("./files/#{login}/pages/", "/uploads/files/#{login}/original/")

          page= Page.new( :user_id=>user.id,
                          :title=>title,
                          :content=>content
                         )
          page.save
          new_id= page.id
          # Добавить в список соответствий id
          # Если в спискок родителей имеет такой id
          page.move_to_child_of(Page.find(ids_set[s.Prev_Id])) if ids_set[s.Prev_Id]
          ids_set[old_id] = new_id
        end# sections.each do |s|
      end# logins.each do |login|
    end# rake db:import:start
  end#:import
end#:db