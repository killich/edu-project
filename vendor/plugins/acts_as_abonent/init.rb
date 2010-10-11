# ������ � ����� lib ������� ������� - ������� ��� acts_as_abonent.rb
require 'acts_as_abonent'

# ��������� ActiveRecord ���. �������������
# �� ��������� ����� ��������� ������������ ������ ������ User
# acts_as_abonent.rb ��������� ������ ������ ActiveRecord ������ SingletonMethods::acts_as_abonent

# ������� acts_as_abonent, ������ ��������� � ������ User
# ��������� include ������ include Killich::Acts::Abonent::AbonentMethods
# ��� ����� ������� ������ User ��������� ��������
ActiveRecord::Base.class_eval do
  include Killich::Acts::Abonent
end

