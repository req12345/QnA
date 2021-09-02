class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many_attached :files
  
  validates :body, presence: true

  def not_best_of?(question)
    self.id != question.best_answer_id
  end
end
