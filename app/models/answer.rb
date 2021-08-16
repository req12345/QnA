class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates :body, :question_id, :user_id, presence: true
end
