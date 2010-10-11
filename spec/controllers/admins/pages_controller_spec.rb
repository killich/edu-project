require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

p '=> ADMIN/Pages Test'

describe Admins::PagesController do

  #Delete these examples and add some real ones
  it "should use Admins::PagesController" do
    controller.should be_an_instance_of(Admins::PagesController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_redirect
    end
  end
end
