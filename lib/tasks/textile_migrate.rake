# Миграция на текскиль
namespace :textile do
  require Rails.root.join('lib', 'html2textile', 'sgml-parser.rb')
  require Rails.root.join('lib', 'html2textile', 'html2textile.rb')
  require 'sanitize'
  require 'redcloth'

  desc 'migration on textile'
  
  # rake textile:migrate  
  task :migrate => :environment do
    Page.all.each do |page|
      begin
        page.prepared_content = page.content
        html = Sanitize.clean(page.prepared_content, SatitizeRules::Config::STRONG_CONTENT)
        html.gsub!("&#13;", "\r\n")
        html.gsub!(">>", "&raquo;")
        html.gsub!("<<", "&laquo;")
        html.gsub!("»", "&raquo;")
        html.gsub!("«", "&laquo;")
        html.gsub!("“", "&quot;")
        html.gsub!("”", "&quot;")
        parser = HTMLToTextileParser.new
        parser.feed(html)
        page.content = parser.to_textile
        html.gsub!(".jpg !", ".jpg!")
      rescue
        puts page.zip
      end
      page.save!
    end
  end#migrate
  #rake textile:page_convert
  
  task :page_convert => :environment do
    file = File.read(Rails.root.join('test_file.txt'))
    parser = HTMLToTextileParser.new
    
    puts '=================================================='
    puts file
    puts '=================================================='
    puts Sanitize.clean(file, {})
    puts '=================================================='
    
    begin
      file = Sanitize.clean(file, SatitizeRules::Config::STRONG_CONTENT)
      parser.feed(file)
      puts parser.to_textile
    rescue Exception => e
      puts e.message
      puts 'Sorry'
    end
    
  end
  
=begin
      html.gsub!("&#13;", "")
      html.gsub!("\t", "")
      html.gsub!("\r", "")
      html.gsub!("\n", "")
      html.gsub!("&", "")
      html.gsub!(";", "")
      html.gsub!("«", "")
      html.gsub!("»", "")
=end
  
end#:db