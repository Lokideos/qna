require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe '.new_questions' do
    let(:questions) { create_list(:question, 2) }
    let(:old_question) { create(:question, created_at: Time.now-90000) }

    it 'should return new questions' do
      expect(Question.new_questions).to include(questions.first)
    end

    it 'should not return old questions' do
      expect(Question.new_questions).to_not include(old_question)
    end
  end

  describe '.new_questions_titles' do
    let(:questions) { create_list(:question, 2) }
    let(:title1) { questions.first.title }
    let(:title2) { questions.last.title }
    let(:titles) { [title1, title2] }
    let(:old_question) { create(:question, created_at: Time.now-90000) }
    let(:old_title) { old_question.title }

    it 'should return new questions titles' do
      expect(Question.new_questions_titles).to include(titles)
    end

    it 'should not return old questions titles' do
      expect(Question.new_questions_titles).to_not include(old_title)
    end
  end

  describe '#add_subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'creates new subscription' do
      expect { question.add_subscription(user) }.to change(question.subscriptions, :count).by(1)
    end

    it 'assign right question and user to the subscription' do
      question.add_subscription(user)
      expect(Subscription.last.user).to eq(user)
      expect(Subscription.last.question).to eq(question)
    end
  end
  
end
