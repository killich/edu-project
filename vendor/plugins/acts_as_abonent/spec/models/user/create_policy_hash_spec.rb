require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '15:07 18.07.2009' do  

  before(:each) do
    @admin= Factory.create(:admin)
  end
    
  # Функция формирования хешей политик для различных уровней правовой системы
  it '23:34 16.07.2009' do
    # Пустые параметры - должна вернуть Hesh
    # @admin.get_policy_hash.should be_instance_of(Hash)
  end# 23:34 16.07.2009
    
end
