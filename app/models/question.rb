class Question < ApplicationRecord
  attr_reader :other_answers
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates :title, :body, presence: true
end
