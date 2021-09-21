class User < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: :user_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :user_id, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
# :confirmable
  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
