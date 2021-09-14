class Answer < ApplicationRecord
  include Votable
  
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def not_best_of?(question)
    self.id != question.best_answer_id
  end
end
