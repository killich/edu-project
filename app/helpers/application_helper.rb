# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Вывод ошибок валидации данного объекта
  def object_errors(obj)
    # Если переданный объект пустой или пустое поле ошибки
    return if (obj.nil? || obj.errors.empty?)
    res= ""

    obj.errors.each do |name, value|
      res<< content_tag(:li, t("#{obj.class.to_s.downcase}.field.#{name}") + " : " + value)
    end
    
    res= content_tag :ul, res
    err_header= ((obj.errors.size>1) ? t('flash.error.many_title') : t('flash.error.title'))
    res= content_tag(:h3, err_header)+res
    res= content_tag :div, res, :class=>:error
    res= content_tag :div, res, :class=>:system_messages
  end
  
  # Вывод стандартных флеш сообщений
  def app_flash(flash)
    res= ''
    # Если переданный объект пустой
    flash.is_a?(Hash) ? nil : (return nil)
    
    if flash[:notice]
      flash_= ''
      flash_= content_tag(:li, flash[:notice])
      flash_= content_tag :ul, flash_
      flash_= content_tag(:h3, t('flash.notice.title'))+flash_
      flash_= content_tag :div, flash_, :class=>:notice
      flash_= content_tag :div, flash_, :class=>:system_messages
      # Обнулим флеш - иногда он имеет свойство проявляться
      flash[:notice]= nil
      res+= flash_
    end
    
    if flash[:red_alert]
      flash_= ''
      flash_= content_tag(:li, flash[:red_alert])
      flash_= content_tag :ul, flash_
      flash_= content_tag(:h3, 'Уведомление')+flash_
      flash_= content_tag :div, flash_, :class=>:error
      flash_= content_tag :div, flash_, :class=>:system_messages
      # Обнулим флеш - иногда он имеет свойство проявляться
      flash[:red_alert]= nil
      res+= flash_
    end
    
    if flash[:warning]
      warn_= ''
      warn_= content_tag(:li, flash[:warning])
      warn_= content_tag :ul, warn_
      warn_= content_tag(:h3, t('flash.warning.system'))+warn_
      warn_= content_tag :div, warn_, :class=>:warning
      warn_= content_tag :div, warn_, :class=>:system_messages
      # Обнулим флеш - иногда он имеет свойство проявляться
      flash[:warning]= nil
      res+= warn_
    end
    
    unless flash[:system_warnings].empty?
      sys_warn_= ''
      flash[:system_warnings].each do |sw|
        sys_warn_+= content_tag(:li, sw)
      end
      
      sys_warn_= content_tag :ul, sys_warn_
      sys_warn_= content_tag(:h3, t('flash.notice.system'))+sys_warn_
      sys_warn_= content_tag :div, sys_warn_, :class=>:warning
      sys_warn_= content_tag :div, sys_warn_, :class=>:system_messages
      # Обнулим флеш - иногда он имеет свойство проявляться
      flash[:warning]= nil
      res+= sys_warn_
    end
    res
  end #app_flash
end
