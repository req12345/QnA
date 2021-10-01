class User < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: :user_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :user_id, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable, omniauth_providers: %i[github vkontakte]

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed?(question)
    subscriptions.where(question: question).exists?
  end
end
