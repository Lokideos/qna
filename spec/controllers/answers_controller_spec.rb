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
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)        
      end

      it 'saves the new answer and its association to correct question' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requestesd answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer' do        
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question.id, id: answer, answer: { body: nil } } }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes answer' do
      expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to related question view' do
      delete :destroy, params: { question_id: question.id, id: answer }
      expect(response).to redirect_to question_answers_path
    end
  end
end
