require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
p 'Application Controller Test'

describe ApplicationController do
  describe "basic app controller properties" do
    it "20:18 13.07.2009, Базовые свойства контроллера приложения должны быть выполнены" do
      # Контроллер приложения должен содержать следующие before фильтры
      # ApplicationController.before_filters
      controller.before_filters.should include(:verify_authenticity_token, :system_init, :find_subdomain, :find_user)
      
      # Должен быть положительный ответ
      # Хотя куда?! мне не понятно =)
      response.should be_success
    end#it 20:18 13.07.2009
  end#basic app controller properties
end