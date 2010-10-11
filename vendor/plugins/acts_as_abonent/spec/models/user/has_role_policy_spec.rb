require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

###################################################################################################
# Тестирование базовой функции проверки политики
###################################################################################################

describe '14:54 18.07.2009' do
  before(:each) do
    @admin= Factory.create(:admin)
    @page_manager_role= Factory.create(:page_manager_role)
  end
  
  # У пользователя нет роли
  it '20:26 18.07.2009' do
    @admin.role_policies_hash.should be_instance_of(Hash)
    @admin.role_policies_hash.should be_empty
    @admin.has_role_policy?(:pages, :manager).should be_false
  end

  # Должен иметь роль и 2 политики доступа
  it '17:40 14.07.2009' do
    @admin.update_attribute(:role_id, @page_manager_role.id)
    @admin.role_policies_hash.should be_instance_of(Hash)
    @admin.role_policies_hash.should have(2).items
    
    @admin.role_policies_hash[:pages].should   have(2).items
    @admin.role_policies_hash[:blocked].should have(2).items

    @admin.has_role_policy?('pages', 'tree').should   be_true
    @admin.has_role_policy?(:pages, :manager).should  be_true
    @admin.has_role_policy?('blocked', :yes).should   be_false
    @admin.has_role_policy?(:blocked, 'no').should    be_true
    
    @admin.has_role_policy?(:pages, :some_stupid_policy).should be_false
  end

  # Проверка базовых политик
  it '12:51 18.07.2009' do
    @admin.update_attribute(:role_id, @page_manager_role.id)
    
    @admin.has_role_policy?(:pages, :tree).should     be_true
    @admin.has_role_policy?(:pages, :manager).should  be_true
    
    @admin.has_role_policy?(:page, :duck).should      be_false
    @admin.has_role_policy?(:pages, :duck).should     be_false
    
    @admin.has_role_policy?(:blocked, :yes).should    be_false
    @admin.has_role_policy?(:blocked, :no).should     be_true
  end   
end