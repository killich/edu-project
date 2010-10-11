require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe PagesController do
    # Проверить наличие before фильтров
    it "18:19 23.07.2009 | 22:39 01.12.2009" do
      controller.before_filters.should include(:login_required)
      controller.before_filters.should include(:page_resourсe_access_required)
      controller.before_filters.should include(:access_to_controller_action_required)
      controller.before_filters.should include(:navigation_menu_init)
      controller.before_filters.should include(:fix_url_by_redirect)
      controller.before_filters.should include(:find_page)
      
      controller.before_filter(:login_required).should                        have_options(:except=>[:index, :show, :edustat, :first])
      controller.before_filter(:page_resourсe_access_required).should         have_options(:only=>[:edit, :update, :destroy, :up, :down])
      controller.before_filter(:access_to_controller_action_required).should  have_options(:only=>[:new, :create, :manager])
      controller.before_filter(:navigation_menu_init).should                  have_options(:except=>[:show, :edustat, :first])
      controller.before_filter(:fix_url_by_redirect).should                   have_options(:only=>[:show])
      controller.before_filter(:find_page).should                             have_options(:only=>[:show, :edit, :update, :destroy, :up, :down])
    end
end