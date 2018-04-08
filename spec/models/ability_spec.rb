require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question_rating) { create :rating, value: 0, ratable: create(:question, user: other), user: user }
    let(:bad_question_rating) { create :rating, value: 0, ratable: create(:question, user: other), user: other }
    let(:answer_rating) { create :rating, value: 0, ratable: create(:answer, user: other), user: user }
    let(:bad_answer_rating) { create :rating, value: 0, ratable: create(:answer, user: other), user: other }
    let(:answer_of_users_question) { create :answer, question: create(:question, user: user), user: user }
    let(:answer_of_not_users_question) { create :answer, question: create(:question, user: other), user: user }
    let(:user_attachment) { create(:attachment, attachable: create(:question, user: user)) }
    let(:other_user_attachment) { create(:attachment, attachable: create(:answer, user: other)) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should be_able_to :update, create(:answer,   user: user), user: user }
    it { should be_able_to :update, create(:comment,  user: user), user: user }

    it { should_not be_able_to :update, create(:question, user: other), user: user }
    it { should_not be_able_to :update, create(:answer,   user: other), user: user }
    it { should_not be_able_to :update, create(:comment,  user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should be_able_to :destroy, create(:answer,   user: user), user: user }
    it { should be_able_to :destroy, create(:comment,  user: user), user: user }

    it { should_not be_able_to :destroy, create(:question, user: other), user: user }
    it { should_not be_able_to :destroy, create(:answer,   user: other), user: user }
    it { should_not be_able_to :destroy, create(:comment,  user: other), user: user }

    it { should be_able_to :rate_good, question_rating.ratable, user: user }
    it { should be_able_to :rate_good, answer_rating.ratable,   user: user }
    it { should be_able_to :rate_bad, question_rating.ratable, user: user }
    it { should be_able_to :rate_bad, answer_rating.ratable,   user: user }

    it { should_not be_able_to :rate_good, bad_question_rating.ratable, user: user }
    it { should_not be_able_to :rate_good, bad_answer_rating.ratable,   user: user }
    it { should_not be_able_to :rate_bad, bad_question_rating.ratable, user: user }
    it { should_not be_able_to :rate_bad, bad_answer_rating.ratable,   user: user }

    it { should be_able_to :cancel_rate, question_rating.ratable, user: user }
    it { should be_able_to :cancel_rate, answer_rating.ratable,   user: user }

    it { should_not be_able_to :cancel_rate, bad_question_rating.ratable, user: user }
    it { should_not be_able_to :cancel_rate, bad_answer_rating.ratable,   user: user }

    it { should be_able_to :choose_best, answer_of_users_question, user: user }
    it { should_not be_able_to :choose_best, answer_of_not_users_question, user: user }

    it { should be_able_to :destroy, user_attachment, user: user }
    it { should_not be_able_to :destroy, other_user_attachment, user: user }
  end
end