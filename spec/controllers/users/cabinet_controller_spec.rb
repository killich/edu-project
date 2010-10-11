require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe UsersController do
    before(:all) do
      @administrator_role=       Factory.create(:administrator_role)
      @site_administrator_role=  Factory.create(:site_administrator_role)

      @admin=           Factory.create(:admin)
      @admin.update_role(@administrator_role)
      
      @ivanov=      Factory.create(:ivanov)
      @ivanov.update_role(@site_administrator_role)
      
      @petrov=      Factory.create(:petrov)
      @petrov.update_role(@site_administrator_role)
    end

    # У пользователей те роли, которые требуются
    it "11:44 16.08.2009" do
      @admin.role.name.should   eql('administrator')
      @ivanov.role.name.should  eql('site_administrator')
      @petrov.role.name.should  eql('site_administrator')
    end
    
    # Доступ только зарегистрированным пользователям
    it "11:44 16.08.2009" do
      get :cabinet
      response.should be_redirect
      response.should redirect_to(new_session_path)
    end
    
    # Администратор просматривает свой кабинет
    it "11:51 16.08.2009" do
      controller.stub!(:current_user).and_return(@admin)
      controller.stub!(:current_subdomain).and_return(@admin.subdomain)
      
      get :cabinet
      
      assigns[:user].should eql(@admin)
      response.should render_template("users/cabinet.haml")
      response.should be_success
    end
    
    # Администратор просматривает кабинет другого пользователя
    it "11:51 16.08.2009" do
      controller.stub!(:current_user).and_return(@admin)
      controller.stub!(:current_subdomain).and_return(@ivanov.subdomain)
      
      get :cabinet
      
      assigns[:user].should eql(@ivanov)
      response.should render_template("users/cabinet.haml")
      response.should be_success
    end
    
    # Пользователь не может просмотреть кабинет администратора
    it "11:53 16.08.2009" do
      controller.stub!(:current_user).and_return(@ivanov)
      controller.stub!(:current_subdomain).and_return(@admin.subdomain)
      
      get :cabinet
      
      assigns[:user].should eql(@admin)
      response.should be_redirect
      response.should redirect_to(new_session_path)
    end
    
    # Пользователь не может просмотреть кабинет другого пользователя
    it "12:08 16.08.2009" do
      controller.stub!(:current_user).and_return(@ivanov)
      controller.stub!(:current_subdomain).and_return(@petrov.subdomain)
      
      get :cabinet
      
      assigns[:user].should eql(@petrov)
      response.should be_redirect
      response.should redirect_to(new_session_path)
    end
    
end