class User < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: :user_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :user_id, dependent: :destroy
  has_many :rewards, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(item)
    id == item.user_id
  end
end
