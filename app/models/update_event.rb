class UpdateEvent < ActiveRecord::Base

  belongs_to :user
  belongs_to :event_object, :polymorphic =>true
  
  # ���� �������
  # page_update, page_create, page_destroy
  
  # ------------------------------------------------------------------  
  # ������� ������� ������� zip ���
  before_validation_on_create :create_zip
  def create_zip
    # ���� zip ��� ���������� �����
    return unless (zip.nil? || zip.empty?)
    zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while self.class.to_s.camelize.constantize.find_by_zip(zip_code)
      zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    self.zip= zip_code
  end
end
