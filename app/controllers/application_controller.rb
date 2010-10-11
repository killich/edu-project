# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  # Система авторизации
  include AuthenticatedSystem
  
  # Простая капча
  include SimpleCaptcha::ControllerHelpers
  
  #rescue_from ActionController::RoutingError, :with => :page_not_found
  #rescue_from ActionController::UnknownAction, :with=> :page_not_found
  #rescue_from WillPaginate::InvalidPage, :with=> :page_not_found
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  layout 'application'
  
  before_filter :system_init    # Инициализация системных переменных
  before_filter :find_subdomain # Определить поддомен в котором мы находимся
  before_filter :find_user      # Определить пользователя системы, к которому мы пытаемся получить доступ (первый уровень поиска)
  before_filter :set_user_language # i18n интернационализация
  
  protected
  
  def page_not_found
    flash[:notice]= 'Раздел к которому Вы пытались обратиться временно не доступен'
    redirect_to root_url
  end

  def system_init 
    # Инициализировать флеш массив с системными уведомлениями
    flash[:system_warnings]= []
  end

  def set_user_language
    #current_user.language if logged_in?
    #cookies[:lang] = 'ru' unless cookies[:lang]
    I18n.locale = cookies[:lang] if cookies[:lang] && ['en', 'ru'].include?(cookies[:lang]) 
    if params[:lang]
      if ['en', 'ru'].include?(params[:lang])
        cookies[:lang] = params[:lang] 
        I18n.locale = params[:lang]
      end
    end
  end
  
  #-------------------------------------------------------------------------------------
  #> Я - НЕ зарегистрированный пользователь
  # перехожу по ссылке без поддомена или user_id
  # При этом просматриваемый пользователь @user - User.find:first
  #> Я - НЕ зарегистрированный пользователь
  # перехожу по ссылке с поддоменом other_user, но без user_id
  # При этом просматриваемый пользователь @user - other_user
  #> Я - НЕ зарегистрированный пользователь
  # перехожу по ссылке без поддомена, но c user_id = other_user
  # При этом просматриваемый пользователь @user - other_user
  #> Я - НЕ зарегистрированный пользователь
  # перехожу по ссылке с поддоменом other_user, и c user_id = other_other_user
  # При этом просматриваемый пользователь @user - other_other_user
  #-------------------------------------------------------------------------------------
  #> Я - зарегистрированный пользователь current_user
  # перехожу по ссылке без поддомена или user_id
  # При этом просматриваемый пользователь @user - должен быть я
  #> Я - зарегистрированный пользователь current_user
  # перехожу по ссылке с поддоменом other_user, но без user_id
  # При этом просматриваемый пользователь @user - должен быть other_user
  #> Я - зарегистрированный пользователь current_user
  # перехожу по ссылке без поддомена, но c user_id = other_user
  # При этом просматриваемый пользователь @user - должен быть other_user
  #> Я - зарегистрированный пользователь current_user
  # перехожу по ссылке с поддоменом other_user, и c user_id = other_other_user
  # При этом просматриваемый пользователь @user - должен быть other_other_user
  #-------------------------------------------------------------------------------------
  
  # Если есть существующий поддомен - то @user - это поддомен
  # Определить поддомен в котором мы находимся
  # По умолчанию - поддомен отсутствует
  # По умолчанию - просматриваемый пользователь - первый, который есть в системе
  # (должен быть администаратор)
  # если мы зарегистрированы в системе, то по умолчанию, просматриваемый пользователь - это мы
  # например /pages/index ведет на просмотр нашего дерева страниц,
  # а для не зарегистрированного пользователя /pages/index ведет на центральное дерево страниц портала
  # поискать приставку www
  # вернуть чистое имя поддомена
  # По найденной приставке - ищем пользователя, если такового нет, то
  # то, нужно выдать ошибку - такой раздел сайта не существует
  # Если указанного поддомена не существует, то генерируем уведомление
  # Возвращаем в качестве пользователя первого пользователя системы  
  # Просматриваем ресурсы
  # Или первого в системе пользователя, или тот, которого нашли по поддомену
  #
  #
  def find_subdomain
    @subdomain= nil
    @author= User.find(:first)
    @user = current_user ? current_user : @author
    @user = @author unless current_subdomain
    
    if current_subdomain
      match= current_subdomain.match(/^www.(.+)/)
      @subdomain= match.nil? ? current_subdomain : match[1]
      user= User.find_by_login(@subdomain)
      unless user
        flash[:system_warnings].push(t('system.domain_does_not_exist'))
        @subdomain= nil
      end
      @user= user ? user : @user
    end
  end
  
  # Если есть существующий пользователь с user_id - то @user - это пользователь с user_id
  def find_user    
    # Схема работы:
    # Если пользователь не найден по поддомену
    # Проверяем параметр params[:user_id] - если он есть и соответствует abcd345efg, то ищем по login
    # Если соответствует 12345456, то ищем по id
    
    # params[:user_id] - для сложносоставных маршрутов, => /users/:user_id/pages/1234-3425-4567-3452 =>:user_id
    
    # Для простых марщрутов - id (проверяем на низких уровнях контроллера) => /users/:id =>:id
    # Нужно определять в Моедли User (по логике, больше нигде не нужно)
    
    # Там сделаю mixin для контроллеров с переопределением def find_user
    if params[:user_id]
      if params[:user_id].match(Format::NUMBERS) # id cовпал с целым числом
        user= User.find_by_id(params[:user_id])
      elsif params[:user_id].match(Format::LOGIN) # id cовпал с login       
        user= User.find_by_login(params[:user_id])
      end #params[:user_id].match
      user ? nil : flash[:system_warnings].push(t('system.section_not_found')+params[:user_id].to_s)
    end #params[:user_id]
    # Просматриваем ресурсы
    # Пользователя ранее найденного по поддомену или того, которого нашли по id || login || zip
    @user= user ? user : @user
  end

  # Функция, необходимая для формирования базового меню-навигации
  # Отображаются только корневые разделы карты сайта
  def navigation_menu_init
    # Должен существовать хотя бы один пользователь
    (render :text=>t('system.have_no_users') and return) unless @user
    @root_pages= Page.find_all_by_user_id_and_parent_id(@user.id, nil, :order=>"lft ASC")
  end
    
  # Перенаправление взамен стандартному
  # Используется в приложении
  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to path
  end
  
  def zip_for_model(class_name)
    zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while class_name.to_s.camelize.constantize.find_by_zip(zip)
      zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    zip
  end
end
