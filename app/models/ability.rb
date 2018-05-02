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
    can :show_answers, Question
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :rate_good, [Question, Answer] do |ratable|
      can_rate?(ratable)
    end
    can :rate_bad, [Question, Answer] do |ratable|
      can_rate?(ratable)
    end
    can :cancel_rate, [Question, Answer] do |ratable|
      can_cancel_rate?(ratable, user)
    end
    can :choose_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best_answer
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end
  end

  def can_cancel_rate?(item, user)
    item.ratings.where(user_id: user.id) && can_rate?(item)
  end

  def can_rate?(item)
    !user.author_of?(item)
  end
end
