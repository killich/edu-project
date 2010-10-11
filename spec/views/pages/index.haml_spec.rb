require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index" do
  before(:each) do
    @administrator_role=       Factory.create(:administrator_role)
    @site_administrator_role=  Factory.create(:site_administrator_role)

    @admin=           Factory.create(:admin)
    @admin.update_role(@administrator_role)
    
    @ivanov=      Factory.create(:ivanov)
    @ivanov.update_role(@site_administrator_role)
    
    @petrov=      Factory.create(:petrov)
    @petrov.update_role(@site_administrator_role)
    
    stub!(:current_user).and_return(@admin)
    assigns[:user]= @admin
    assigns[:pages_tree]= Array.new
      
    render 'pages/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('h5', %r[Нет страниц с содержимым для отображения])
  end
end
