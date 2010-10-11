require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe PagesController do
    # Создать zip код для страницы
    def create_zip_for_page
      zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
      while Page.find_by_zip(zip)
        zip= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
      end
      zip
    end
    
    before(:each) do
      # Создать роли
      @registrated_user_role=    Factory.create(:registrated_user_role)
      @guaranted_user_role=      Factory.create(:guaranted_user_role)
      @site_administrator_role=  Factory.create(:site_administrator_role)
      @page_administrator_role=  Factory.create(:page_administrator_role)
      @administrator_role=       Factory.create(:administrator_role)
      
      # Имеет доступ к edit страниц всех пользователей
      @admin= Factory.create(:empty_user, :login=>'admin', :email=>'admin@email.com')
      @admin.update_role(@administrator_role)
      @admin_page= Factory.create(:test_page, :user_id=>@admin.id, :zip=>create_zip_for_page)
      
      # Имеет доступ к edit страниц всех пользователей
      @page_administrator= Factory.create(:empty_user, :login=>'page_administrator', :email=>'page_administrator@email.com')
      @page_administrator.update_role(@page_administrator_role)
      @page_administrator_page= Factory.create(:test_page, :user_id=>@page_administrator.id, :zip=>create_zip_for_page)
      
      # Имеет доступ только к edit только своей страницы
      @site_administrator= Factory.create(:empty_user, :login=>'site_administrator_role', :email=>'site_administrator@email.com')
      @site_administrator.update_role(@site_administrator_role)
      @site_administrator_page= Factory.create(:test_page, :user_id=>@site_administrator.id, :zip=>create_zip_for_page)
      
      # Не имеет никакого доступа к edit
      @guaranted_user= Factory.create(:empty_user, :login=>'guaranted_user', :email=>'guaranted_user@email.com')
      @guaranted_user.update_role(@guaranted_user_role)
      
      # Не имеет никакого доступа к edit
      @registrated_user= Factory.create(:empty_user, :login=>'registrated_user', :email=>'registrated_user@email.com')
      @registrated_user.update_role(@registrated_user_role)    
    end
    
    after(:all) do
      User.destroy_all
    end

    # У пользователей те роли, которые требуются
    it "18:24 23.07.2009" do
      @admin.role.name.should                 eql('administrator')
      @page_administrator.role.name.should    eql('page_administrator')
      @site_administrator.role.name.should    eql('site_administrator')
      @guaranted_user.role.name.should        eql('guaranted_user')
      @registrated_user.role.name.should      eql('registrated_user')
    end
    
    # У нужных пользователей есть страницы
    it "18:24 23.07.2009" do
      @admin.pages.should have(1).item
      @page_administrator.pages.should have(1).item
      @site_administrator.pages.should have(1).item
      @guaranted_user.pages.should have(:no).items
      @registrated_user.pages.should have(:no).items
    end
    
    # pages::edit routing    
    it "11:09 31.01.2010" do
      edit_page_path(:id=>1).should == '/pages/1/edit'
      edit_page_url(:id=>1).should == 'http://test.host/pages/1/edit'
      
      edit_page_path(:subdomain=>@admin.login, :id=>1).should == 'http://admin.test.host/pages/1/edit'
      edit_page_url(:subdomain=>@admin.login, :id=>1).should == 'http://admin.test.host/pages/1/edit'

      edit_page_path(:subdomain=>@admin.login, :id=>1).should == 'http://admin.test.host/pages/1/edit'
      edit_page_url(:subdomain=>@admin.login, :id=>1).should == 'http://admin.test.host/pages/1/edit'
      
      params_from(:get, '/pages/1/edit').should == {:controller => 'pages', :action => 'edit', :id=>'1'}
    end

#---------------------------------------------------------------
# АДМИНИСТРАТОР
#---------------------------------------------------------------
    
    # Администратор заходит редактировать свою страницу
    # current_user= @admin
    # @user= @admin
    it "14:02 02.08.2009" do
      controller.stub!(:current_user).and_return(@admin)
      controller.stub!(:current_subdomain).and_return(@admin.login)

      # de facto: get 'http://admin.test.host/pages/:id/edit'
      get :edit, :id=>@admin_page.zip
      
      assigns[:user].should == @admin
      response.should render_template("pages/edit.haml")
      response.should be_success
    end

    # Администратор заходит редактировать свою страницу
    # current_user= @admin
    # @user= @admin
    it "14:02 02.08.2009" do
      controller.stub!(:current_user).and_return(@admin)

      # de facto: get 'http://test.host/users/admin/pages/:id/edit'
      get :edit, :user_id=>'admin', :id=>@admin_page.zip
      
      assigns[:user].should eql(@admin)
      response.should render_template("pages/edit.haml")
      response.should be_success
    end
    
    # Администратор заходит редактировать свою страницу
    # current_user= @admin
    # @user= @admin
    it "14:02 02.08.2009" do
      controller.stub!(:current_user).and_return(@admin)

      # de facto: get 'http://test.host/pages/:id/edit'
      get :edit, :id=>@admin_page.zip
      
      assigns[:user].should eql(@admin)
      response.should render_template("pages/edit.haml")
      response.should be_success
    end
    
    # Администратор заходит редактировать страницу пользователя-администратора сайта 
    # current_user= @admin
    # @user= @site_administrator
    it "14:02 02.08.2009" do
      controller.stub!(:current_user).and_return(@admin)
      controller.stub!(:current_subdomain).and_return(@site_administrator.login)

      # de facto: get 'http://site_administrator.test.host/pages/:id/edit'
      get :edit, :id=>@site_administrator_page.zip
      
      assigns[:user].should eql(@site_administrator)
      response.should render_template("pages/edit.haml")
      response.should be_success
    end
    
    it "11:42 31.01.2010" do
      # А вот сам администратор сайта зайти в edit страницы администратора портала не может
      # current_user= @site_administrator
      # @user= @admin
      controller.stub!(:current_user).and_return(@site_administrator)
      controller.stub!(:current_subdomain).and_return(@admin.login)
      
      # de facto: get 'http://admin.test.host/pages/:id/edit'
      get :edit, :id=>@admin_page.zip
=begin
      p '---------------------------------- 1'
      p controller.send(:current_subdomain)      
      p '---------------------------------- 1'
      p controller.send(:current_user)
      p '---------------------------------- 2'
      p assigns[:subdomain]
      p '---------------------------------- 3'
      p assigns[:user]
      p '---------------------------------- 4'
      p @site_administrator
      p '---------------------------------- 5'
      p @admin
=end
      controller.send(:current_user).should == @site_administrator
      assigns[:user].should == @admin
      response.should_not be_success
      response.should be_redirect
      response.should_not be_success
      response.should redirect_to(new_session_path)  
    end
    
    # Администратор заходит редактировать страницу которой не существует
    # current_user= @admin
    # @user= @admin
    it "14:02 02.08.2009" do
      controller.stub!(:current_user).and_return(@admin)
      controller.stub!(:current_subdomain).and_return(@admin.login)

      # de facto: get 'http://admin.test.host/pages/:id/edit'
      get :edit, :id=>123454321
      
      assigns[:user].should eql(@admin)
      response.should_not be_success
      response.should redirect_to(new_session_path)
    end

#---------------------------------------------------------------
# ГОСТЬ
#---------------------------------------------------------------

    # Гость заходит редактировать страницу Администратора
    # current_user= nil
    # @user= @admin
    it "14:02 02.08.2009" do
      controller.stub!(:current_subdomain).and_return(@admin.login)

      # de facto: get 'http://admin.test.host/pages/:id/edit'
      get :edit, :id=>@admin_page.zip
      
      assigns[:user].should eql(@admin)
      response.should_not be_success
      response.should redirect_to(new_session_path)
    end
    
    # Гость заходит редактировать не существующую страницу
    # current_user= nil
    # @user= @admin
    it "14:02 02.08.2009" do
      # de facto: get 'http://admin.test.host/pages/:id/edit'
      get :edit, :id=>123454321
      
      assigns[:user].should eql(@admin)
      response.should_not be_success
      response.should redirect_to(new_session_path)
    end
    
    # Следующее что предстоит сделать
    # Это отследить персональные политики и
    # Проверить функционирование счетчиков,
    # Которые при исполнении политики должны инкрементироваться
    # только в тех хешах, в которых актуальны и обновляться в БД
    
    # Поведенческое тестирование должно
    # Проверить как функционирую хеши в зависимости от приоритета
    # который залохен в логике фильтров
    
    # На данный момент я предполагаю, что все функционирует верно
    # Начинаю работу по запуску прототипа
    # 20:09 02.08.2009
    
end