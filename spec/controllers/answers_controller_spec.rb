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
    before { get :show, params: { question_id: question.id, id: answer } }

    it 'assign the requested answer to @answer' do      
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do      
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question.id, id: answer } }

    it 'assign the requested answer to @answer' do      
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do      
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
  end

  describe 'PATCH #update' do
  end

  describe 'DELETE #destroy' do

  end

end
