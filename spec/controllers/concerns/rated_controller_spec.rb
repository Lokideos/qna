require 'rails_helper'

shared_examples "Rated" do
  let(:rating) { create(:rating, value: 0)}
  
  describe 'PATCH #rate_good' do
    it "changes rating's value" do
      patch :rate_good, params: { id: rating, format: :js }
      rating.reload
      expect(rating.value).to eq 1
    end
  end

  describe 'PATCH #rate_bad' do
    it "changes rating's value" do 
      patch :rate_bad, params: { id: rating, format: :js}
      rating.reload
      expect(rating.value).to eq -1
    end
  end
end

describe QuestionsController, type: :controller do
  it_behaves_like "Rated"
end

describe AnswersController, type: :controller do
  it_behaves_like "Rated"
end
