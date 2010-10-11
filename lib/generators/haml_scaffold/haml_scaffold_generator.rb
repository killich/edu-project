# HamlScaffoldViewGenerator
# Ilya Zykin 22:24 24.03.2009

# Генератор Стандартных Скаффолдов на HAML
# >ruby script/generate haml_scaffold user namespace:ultra

class HamlScaffoldGenerator < Rails::Generator::NamedBase
  default_options :namespace => "admin", :display_block => true
            
  def manifest
  
    # parse incoming attributes and update options
    for attribute in attributes
     case attribute.name
       when 'namespace'
         options[:namespace] = attribute.type.to_s
       when 'display_block'
         options[:display_block] = false
         p options[:display_block]
     end
    end
  
    view_path= options[:namespace].blank? ? "app/views/#{file_name.pluralize}" : "app/views/#{options[:namespace]}/#{file_name.pluralize}"
    yaml= YAML.load_file("lib/generators/haml_scaffold/config/#{file_name}.model.yaml")
    
    # Если объект настроек определен, то проведем его по всем шаблонам и сгенерим нужные виды
    if yaml[:model]
      record do |m|
        m.directory('public/stylesheets/haml_scaffolds')
        m.directory(view_path)
        
        m.file('reset.css', 'public/stylesheets/haml_scaffolds/reset.css')
        m.file('style.css', 'public/stylesheets/haml_scaffolds/style.css')
        m.file('haml_scaffold_layout.haml', 'app/views/layouts/haml_scaffold_layout.haml')
        
        m.template  "index.rb", "#{view_path}/index.haml",  :assigns=>{ :model=>file_name, :struct=>yaml[:model], :scope=>options[:namespace], :display_block=> options[:display_block] }
        m.template  "edit.rb",  "#{view_path}/edit.haml",   :assigns=>{ :model=>file_name, :struct=>yaml[:model], :scope=>options[:namespace] }
        m.template  "new.rb",   "#{view_path}/new.haml",    :assigns=>{ :model=>file_name, :struct=>yaml[:model], :scope=>options[:namespace] }
        m.template  "show.rb",  "#{view_path}/show.haml",   :assigns=>{ :model=>file_name, :struct=>yaml[:model], :scope=>options[:namespace] }
        
        unless options[:namespace].blank?
          m.directory("app/controllers/#{options[:namespace]}") # создать папку
          m.template  "controller.rb",  "app/controllers/#{options[:namespace]}/#{file_name.pluralize}_controller.rb", :assigns=>{ :model=>file_name, :scope=>options[:namespace] }
        else
          m.template  "controller.rb",  "app/controllers/#{file_name.pluralize}_controller.rb", :assigns=>{ :model=>file_name }
        end
      end
    else
      p "Have no element - yaml[:model]"
    end
  end
=begin
  # Basic iterators
    struct.each do |elem|
      elem.each do |field_name, param|
        = param[:title]
      end
    end #struct.each do |elem|
=end
end
