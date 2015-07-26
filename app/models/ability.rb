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

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :manage, :profile

    alias_action :create, :read, :update, :destroy, to: :crud
    can :crud, [Question, Answer], user: user
    can :create, Comment

    can :manage, Attachment do |attachment|
      user.owns?(attachment.attachable)
    end

    can :mark_solution, Answer do |answer|
      user.owns?(answer.question)
    end

    can :vote_up, [Question, Answer] do |votable|
      can_vote?(votable, 1)
    end
    can :vote_down, [Question, Answer] do |votable|
      can_vote?(votable, -1)
    end
    can :vote_cancel, [Question, Answer] do |votable|
      !user.owns?(votable) && votable.voted_by?(user)
    end
  end

  def can_vote?(votable, value)
    !(user.owns?(votable) || votable.voted_by?(user, value))
  end
end
