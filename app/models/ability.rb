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
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user
    can :rate_good, [Question, Answer]
    cannot :rate_good, [Question, Answer], user: user
    can :rate_bad, [Question, Answer]
    cannot :rate_bad, [Question, Answer], user: user
    can :cancel_rate, [Question, Answer]
    cannot :cancel_rate, [Question, Answer], user: user
    can :choose_best, Answer do |answer|
      answer.question.user == user
    end
  end
end
