# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  #-------------------------------------------------------------------------------------------------------
  # Информация о связанных плагинах и гемах
  #-------------------------------------------------------------------------------------------------------
      
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Предполагается, что начальная инициализация данных приожения
  # будет проводится при помощи Фабрик
  #config.gem "thoughtbot-factory_girl",
  #         :lib    => "factory_girl",
  #         :source => "http://gems.github.com"
             
  # Для тестового заполнения данными требуется gem faker
  # Установка всех гемов выполняется командой
  # rake gems:install # если надо указать среду разработки RAILS_ENV=test
  # rake gems:install RAILS_ENV=test
  # rspec - используется для тестирования

  # Деревья страниц
  # http://github.com/collectiveidea/awesome_nested_set/tree/master
  # script/plugin install git://github.com/collectiveidea/awesome_nested_set.git

  #-------------------------------------------------------------------------------------------------------
  # ~Информация о связанных плагинах и гемах
  #-------------------------------------------------------------------------------------------------------

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Moscow'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'en', '*.{rb,yml}')]
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.{rb,yml}')]
  config.i18n.default_locale = :ru
end

# Убирает в формах дивы обрамляющие поля с ошибками
ActionView::Base.field_error_proc = proc { |input, instance| input }
# Настройка ключа сессии для всех поддоменов. Авторизация действительная для всех поддоменов
# ActionController::Base.session_options[:session_domain] = Site::COOKIES_SCOPE [rails < 2.3]
ActionController::Base.session_options[:domain] = Project::COOKIES_SCOPE
ActionController::Base.asset_host = Project::ADDRESS

require 'sanitize'
require 'redcloth'

# Данное определение можно убрать после запуска rake файлов, подготовливающих систему к запуску
# require 'factory_girl'
# require 'faker'
