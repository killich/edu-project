class Profile < ActiveRecord::Base
  # Профайл пользователя (Анкета пользователя)
  belongs_to :user
  
  # ------------------------------------------------------------------  
  # Создать данному объекту zip код
  before_create :create_zip
  def create_zip
    zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while self.class.to_s.camelize.constantize.find_by_zip(zip_code)
      zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    self.zip= zip_code
  end
end
