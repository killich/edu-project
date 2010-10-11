class Question < ActiveRecord::Base    
  belongs_to :user
 
  # Валидация
  validates_presence_of :from
  validates_presence_of :to
  validates_presence_of :topic
  validates_presence_of :question  
  apply_simple_captcha :message=>'ошибка ввода защитных символов'

  # Подготовка полей перед сохранением
  before_save :prepare_fields
  
  # Подготовка полей перед сохранением
  def prepare_fields
    (self.question = self.question.mb_chars[0..600]) unless (self.question.nil? || self.question.blank?)
  end
  
  #new_question, seen, blocked, publicated, deleted
  # ------------------------------------------------------------------
  # Машина состояний state
  state_machine :state, :initial => :new_question do    
    # Чтание нового сообщения
    event :reading do
      # Новый вопрос просматривается и изменяет свое состояние
      transition :new_question => :seen
    end
    
    # Блокировка сообщения
    event :blocking do
      # Из всех состояний кроме delete должен перейти в это
      transition all - :deleted => :blocked
    end
    
    # Публикация сообщения
    event :publication do
      # Из просмотренного в публикацию
      transition :seen => :publicated
    end
    
    # Снять с публикации
    event :unpublication do
      # Из опубликованного в просмотреные (снять с публикации)
      transition :publicated => :seen
    end
    
    # Разблокировка сообщения
    event :unblocking do
      # Из состояния бока перейти в состояние просмотренного сообщения
      transition :block => :seen
    end
    
    # Удаление сообщения
    event :deleting do
      # Из всех состояний должен перейти в это
      transition all => :deleted
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
