require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Работоспособность маршрутизации
describe PagesController do  
  before(:each) do
    @admin= Factory.create(:admin)
    @ivanov= Factory.create(:ivanov)
    @petrov= Factory.create(:petrov)
  end
    
  # Хелпер пути должен формировать следующий путь
  it "20:46 23.07.2009" do
    pages_path.should                       == '/pages'
    pages_url.should                        == 'http://test.host/pages'
    
    pages_path(:subdomain=>'petrov').should == 'http://petrov.test.host/pages'
    pages_url(:subdomain=>'petrov').should  == 'http://petrov.test.host/pages'
  end
  
  # Если не указано никаких других параметров
  # То будет в качестве отображаемого пользователя
  # выставлен первый пользователь системы
  it "20:47 23.07.2009" do
    get pages_path
    assigns[:user].should eql(@admin)
  end
  
=begin
  #user_pages_url(:user_id=>'petrov').should                       == 'http://test.host/users/petrov/pages'
  #user_pages_path(:user_id=>'petrov').should                      == '/users/petrov/pages'
  #user_pages_path(:subdomain=>'petrov', :user_id=>'admin').should == 'http://petrov.test.host/users/admin/pages'
  #user_pages_url(:subdomain=>'petrov', :user_id=>'admin').should  == 'http://petrov.test.host/users/admin/pages'

  #route_for(:controller => 'pages', :action => 'index').should          == '/pages/'
  #route_for(:controller => 'pages', :action => 'show', :id=>'1').should == '/pages/show/1'
  #params_from(:get, "/pages/show/22").should == {:controller => 'pages', :action => 'show', :id=>'22'}
  #params_from(:get, "/pages/show/17").should == {:controller => 'pages', :action => 'show', :id=>'17'}
  #params_from(:get, user_pages_path(:user_id=>1)).should == {:controller => 'pages', :action => 'index', :user_id=>'1'}
  #params_from(:get, user_pages_path(:user_id=>'admin')).should == {:controller => 'pages', :action => 'index', :user_id=>'admin'}
  #params_from(:get, user_pages_url(:user_id=>'petrov', :subdomain=>'admin')).should == {:controller => 'pages', :action => 'index', :user_id=>'petrov'}


  Невозможно протестировать поведение схемы определения просматриваемого пользователя
  Пока мне не известно как при вызове url
  get pages_path или get pages_url
  Заставить request содержать в себе subdomains (request.subdomains)
  До этих пор я могу только тестировать предустановленные значения пользователей
  current_user
  @user
  В надежде, что схема работает правильно
  Формировать правовое распределение и тестировать доступ пользователей

  it "20:47 23.07.2009" do
    get pages_path
    assigns[:user].should eql(@admin)
    
    get pages_url
    assigns[:user].should eql(@admin)
  end
  
  it "20:48 23.07.2009" do    
    controller.stub!(:current_subdomain).and_return(@petrov.login)
    get pages_path(:subdomain=>'petrov')
    assigns[:user].should eql(@petrov)
    
    controller.stub!(:current_subdomain).and_return(@petrov.login)
    get pages_url(:subdomain=>'petrov')
    assigns[:user].should eql(@petrov)
  end
  
  it "22:39 01.08.2009" do        
    #params_from(:get, 'http://admin.test.host/users/petrov/pages').should == {:controller => 'pages', :action => 'index', :user_id=>'petrov'}
    #asserts[:user]==@petrov
    #params_from(:get, 'http://admin.test.host/pages').should == {:controller => 'pages', :action => 'index'}
    #asserts[:user]==@admin
    #params_from(:get, 'http://petrov.test.host/pages').should == {:controller => 'pages', :action => 'index'}
    #asserts[:user]==@petrov
  end
=end
end