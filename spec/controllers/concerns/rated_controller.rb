require 'rails_helper'

shared_examples "Rated" do
  let(:author_of_qna) { create(:user) }
  let (:ratable_question) { create(:question, user: author_of_qna) }
  let (:ratable_answer) { create(:answer, question: ratable_question, user: author_of_qna)}
  
  describe 'PATCH #rate_good' do
    sign_in_user

    it "creates new good rating"

    it "changes rating's value" do
      patch :rate_good, params: { id: question, format: :json }
      patch :rate_good, params: { question_id: ratable_question, id: ratable_answer, format: :json }
      ratable_question.reload
      ratable_answer.reload
      expect(ratable_question.ratings.first.value).to eq 1
      expect(ratable_answer.ratings.first.value).to eq 1
    end
  end

  describe 'PATCH #rate_bad' do
    sign_in_user

    it "creates new bad rating"

    it "changes rating's value" do 
      patch :rate_bad, params: { id: ratable_question, format: :json }
      patch :rate_bad, params: { question_id: ratable_question, id: ratable_answer, format: :json }
      ratable_question.reload
      ratable_answer.reload
      expect(ratable_question.ratings.first.value).to eq -1
      expect(ratable_answer.ratings.first.value).to eq -1
    end
  end

  describe 'PATCH #cancel_rate' do
    sign_in_user

    it "changes rating's value" do 
      patch :cancel_rate, params: { id: ratable_question, format: :json }
      patch :cancel_rate, params: { question_id: ratable_question, id: ratable_answer, format: :json }
      ratable_question.reload
      ratable_answer.reload
      expect(ratable_question.ratings.first).to eq nil
      expect(ratable_question.ratings.first).to eq nil
    end
  end
end
