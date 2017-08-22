require 'rails_helper'

RSpec.describe Answer, type: :model do

  context "Associations" do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent(:destroy) }
  end

  context 'methods test' do

    describe "#choose_best_answer" do
      let(:user){ create(:user) }
      let(:question){ create(:question, user: user) }

      it "choose_best_answer method should update best_answer field" do
        answer = create(:answer, question: question, user: user)
        answer.choose_best_answer(answer)

        expect(answer.best_answer).to eq true
      end

      it "choose_best_answer method should update best_answer field if there is another best answer" do
        answer = create(:answer, question: question, user: user, best_answer: true)
        answer2 = create(:answer, question: question, user: user)
        answer2.choose_best_answer(answer2)

        expect(answer2.best_answer).to eq true
      end
    end

  end

  context "Validations" do

    it { should validate_presence_of :body }

    it "should validate uniquness of best answer" do
      user = create(:user)
      question = create(:question, user: user)
      answer = create(:answer, question: question, user: user, best_answer: true)
      answer2 = create(:answer, question: question, user: user)

      answer2.update(best_answer: true)
      expect(answer2).to_not be_valid
    end
  end

  it { should accept_nested_attributes_for :attachments }
end
