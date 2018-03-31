require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'POST #create' do
    sign_in_user
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }

    it 'loads question if parent is question' do
      post :create, params: { question_id: question, comment: attributes_for(:comment), format: :json }
      expect(assigns(:commentable)).to eq question
    end

    it 'loads answer if parent is answer' do 
      post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :json }      
      expect(assigns(:commentable)).to eq answer
    end
  end
end
