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
    can :create, [Question, Answer] 
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :voted_down, [Question, Answer]
    can :voted_up, [Question, Answer]
    can :revote, [Question, Answer]
    cannot :voted_down, [Question, Answer], user: user 
    cannot :voted_up, [Question, Answer], user: user
    cannot :revote, [Question, Answer], user: user
    can :update_best_answer, Answer do |answer| 
      answer.question.user == user
    end
  end
end
