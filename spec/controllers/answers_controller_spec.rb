require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'GET #index' do    
    let(:answers) { question; create_list(:answer, 2) }

    before { get :index, params: { question_id: question.id } }

    it 'populates array array of all answers to this questions' do      
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render index view' do      
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assign the requested answer to @answer' do
      get :show, params: { question_id: question.id, id: answer }
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      get :show, params: { question_id: question.id, id: answer }
      expect(response).to render_template :show
    end
  end

end
