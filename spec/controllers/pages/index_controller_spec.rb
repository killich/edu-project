require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe PagesController do
    before(:all) do
      @registrated_user_role=    Factory.create(:registrated_user_role)
      @page_administrator_role=  Factory.create(:page_administrator_role)
      @administrator_role=       Factory.create(:administrator_role)
      
      @admin= Factory.create(:admin, :login=>'new_admin', :email=>'new_admin@mail.ru')
      @admin.update_role(@administrator_role)
      
      @page_admin= Factory.create(:empty_user, :login=>'page_admin', :email=>'page_admin@email.com')
      @page_admin.update_role(@page_administrator_role)
      
      @registrated_user= Factory.create(:empty_user, :login=>'registrated_user_index', :email=>'registrated_user_index@email.com')
      @registrated_user.update_role(@registrated_user_role)
    end
    
    after(:all) do
      User.destroy_all
    end

    # У пользователей те роли, которые требуются
    it "18:24 23.07.2009" do
      @admin.role.name.should             eql('administrator')
      @page_admin.role.name.should        eql('page_administrator')
      @registrated_user.role.name.should  eql('registrated_user')
    end
    
    # Общедоступная страница
    it "18:24 23.07.2009" do
      get :index
      response.should render_template('pages/index.haml')
      response.should_not be_redirect
    end
    
    # действие index
=begin
      #@guaranted_user_role=      Factory.create(:guaranted_user_role)
      #@site_administrator_role=  Factory.create(:site_administrator_role)
    #response.should redirect_to(root_path(:subdomain=>'admin'))
    
    # Нет никаких данных в системе
    it "18:24 23.07.2009" do
      controller.stub!(:current_subdomain).and_return(@admin.login)
      
      get :index
      
      assigns[:user].should eql(@admin)
      assigns[:pages_tree].should be_empty
    end
    
    # Зашли в поддомен @petrov
    it "18:42 23.07.2009" do
      controller.stub!(:current_subdomain).and_return(@petrov.login)
      
      get :index
      
      assigns[:user].should eql(@petrov)
      assigns[:pages_tree].should be_empty
    end
    
    # Зашли в поддомен @petrov, но путь вида /users/1/pages приоритетнее
    # Войдем под администратором
    it "18:42 23.07.2009" do
      controller.stub!(:current_subdomain).and_return(@petrov.login)
      
      #user_pages_path(:user_id=>@admin.id)
      get '/users/admin/pages', :user_id=>@admin.login
      assigns[:user].should eql(@admin)
      
      get '/users/ivanov/pages', :user_id=>@ivanov.id
      assigns[:user].should eql(@ivanov)
      #assigns[:pages_tree].should be_empty
    end
=end
end