# frozen_string_literal: true

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

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
    cannot :voted_down, [Question, Answer]
    cannot :voted_up, [Question, Answer]
    cannot :revote, [Question, Answer]
    cannot :update_best_answer, Answer
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, QuestionSubscribe] 
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:voted_down, :voted_up], [Question, Answer] do  |votable| 
      !user.author_of?(votable) 
    end
    can :revote, [Question, Answer] do |votable|
      user.voted?(votable) 
    end
    can :update_best_answer, Answer, question: {user_id: user.id }
  end
end
