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
    vote = Vote.find_by(user_id: user.id)
    return if vote == nil && vote_author?(user)
    votes.destroy(vote)
  end

  def rating
    votes.sum(:value)
  end

  def vote_author?(user)
    votes.exists?(user: user)
  end
end
