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
    let(:author) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }
    
    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :update, create(:comment, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:comment, user: user), user: user }
    it { should_not be_able_to :destroy, create(:comment, user: other), user: user }

    it { should be_able_to :rate_good, create(:question, user: other), user: user }
    it { should_not be_able_to :rate_good, create(:question, user: user), user: user }

    it { should be_able_to :rate_good, create(:answer, user: other), user: user }
    it { should_not be_able_to :rate_good, create(:answer, user: user), user: user }

    it { should be_able_to :rate_bad, create(:question, user: other), user: user }
    it { should_not be_able_to :rate_bad, create(:question, user: user), user: user }

    it { should be_able_to :rate_bad, create(:answer, user: other), user: user }
    it { should_not be_able_to :rate_bad, create(:answer, user: user), user: user }

    it { should be_able_to :cancel_rate, create(:question, user: other), user: user }
    it { should_not be_able_to :cancel_rate, create(:question, user: user), user: user }

    it { should be_able_to :cancel_rate, create(:answer, user: other), user: user }
    it { should_not be_able_to :cancel_rate, create(:answer, user: user), user: user }

    it { should be_able_to :choose_best, create(:answer, question: question, user: user), user: user }
    it { should be_able_to :choose_best, create(:answer, question: question, user: other), user: user }
    it { should_not be_able_to :choose_best, create(:answer, question: question, user: author), user: author }
    it { should_not be_able_to :choose_best, create(:answer, question: question, user: author), user: other }
  end
end