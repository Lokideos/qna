require 'rails_helper'

RSpec.describe Answer, type: :model do

  context "Associations" do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  context 'methods test' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }    

    it "choose_best_answer method should update best_answer field" do
      answer = create(:answer, question: question, user: user)
      expect(answer.choose_best_answer(answer)).to eq true
    end

    it "choose_best_answer method should update best_answer field if there is another best answer" do
      answer = create(:answer, question: question, user: user, best_answer: true)
      answer2 = create(:answer, question: question, user: user)

      expect(answer.choose_best_answer(answer2)).to eq true
    end

  end

  context "Validations" do
    it { should validate_presence_of :body }
  end
end
