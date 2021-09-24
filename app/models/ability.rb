class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    can :read, :all
    can [:create, :create_comment], [Question, Answer, Comment]
    can [:destroy, :update], [Question, Answer], user_id: user.id
    can :destroy, Link, linkable: { user_id: user.id }
    can [:vote_for, :vote_against, :cancel_voting], [Question, Answer] do |votable|
      votable.user_id != user.id
    end
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
    can :mark_as_best, Answer, question: {user_id: user.id}
  end
end
