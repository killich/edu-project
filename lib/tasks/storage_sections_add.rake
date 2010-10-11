# Добавить пользователям разделы для файлов
namespace :storage do

  desc 'storage add sections'
  # rake storage:add
  task :add => :environment do
    User.find(:all, :conditions=>{:id => 1..7}).each do |user|
      user.storage_sections.new(:title=>'Изображения').save!
      user.storage_sections.new(:title=>'Текстовые документы').save!
      user.storage_sections.new(:title=>'Электронные таблицы').save!
      user.storage_sections.new(:title=>'Презентации').save!
      user.storage_sections.new(:title=>'Другие файлы').save!
    end
  end#add
  # rake storage:add
end#:db