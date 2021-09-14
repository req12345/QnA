module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_for(user)
    votes.create!(user: user, value: 1) unless votes.exists?(user: user)
  end

  def rating
    votes.sum(:value)
  end
end
