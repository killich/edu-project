require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

p '=> Users Test'

describe UsersController do

  #index тестирование
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

end
