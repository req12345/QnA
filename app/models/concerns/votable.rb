module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_for(user)
    votes.create!(user: user, value: 1) unless vote_author?(user)
  end

  def vote_against(user)
    votes.create!(user: user, value: -1) unless vote_author?(user)
  end

  def cancel_voting(user)
    vote = Vote.where(user_id: user.id)
    votes.destroy(vote) if vote_author?(user)
  end

  def rating
    votes.sum(:value)
  end

  def vote_author?(user)
    votes.exists?(user: user)
  end
end
