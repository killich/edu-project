require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe UsersController do
    # Проверить наличие before фильтров
    it "11:38 16.08.2009" do
      controller.before_filters.should include(:navigation_menu_init)
      controller.before_filters.should include(:login_required)

      controller.before_filter(:login_required).should                        have_options(:except=>[:index, :new, :create])
    end
end