class Page < ActiveRecord::Base  
  # Действуй как дерево, привязанное к владельцу (пользователю)
  acts_as_nested_set :scope=>:user
  belongs_to :user
  
  validates_presence_of :user_id,     :message=>"Не определен идентификатор владельца страницы"
  validates_presence_of :zip,         :message=>"Не определен zip-идентификатор страницы"

  #validates_presence_of :author
  #validates_presence_of :keywords
  #validates_presence_of :description
  #validates_presence_of :copyright
  validates_presence_of :title, :message=>"У страницы должен быть заголовок"

  #publicated, hidden
  state_machine :state, :initial => :hidden do
    # Публикация новости
    event :publication do
      transition :hidden => :publicated
    end
    # Снятие с публикации
    event :hiding do
      transition :publicated => :hidden
    end    
    event :fixer do
      transition :show => all
    end
  end

        
  # ------------------------------------------------------------------  
  # Создать данному объекту zip код
  before_validation_on_create :create_zip
  def create_zip
    # Если zip уже установлен ранее
    return unless (zip.nil? || zip.empty?)
    zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    while self.class.to_s.camelize.constantize.find_by_zip(zip_code)
      zip_code= "#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}-#{(1000..9999).to_a.rand}"
    end
    self.zip= zip_code
  end
end
