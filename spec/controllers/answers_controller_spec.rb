require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { question_id: question.id, id: answer } }

    it 'assign the requested answer to @answer', js: true do      
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do      
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)        
      end

      it 'saves the new answer and its association to correct user' do
        expect { post :create, params: { question_id: question.id, answer:attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)        
      end

      it 'saves the new answer and its association to correct question' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template ('answers/create')        
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'render question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template ('answers/create')
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'assigns the requestesd answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the updated answer' do        
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do

      it 'does not change answer attributes' do
        correct_body = answer.body
        patch :update, params: { question_id: question.id, id: answer, answer: { body: nil }, format: :js }
        answer.reload
        expect(answer.body).to eq correct_body
      end

      it 'render related quesiton view' do
        patch :update, params: { question_id: question.id, id: answer, answer: { body: nil }, format: :js }
        expect(response).to render_template ('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { answer }

    context 'with valid author' do
      before { controller.stub(:current_user).and_return (user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer, format: :js } }.to change(question.answers, :count).by(-1)
      end

      it 'render related question view' do
        delete :destroy, params: { question_id: question.id, id: answer, format: :js }
        expect(response).to redirect_to question_path(assigns(:question))        
      end
    end
    
    context 'with invalid author' do

      it 'not deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer, format: :js } }.not_to change(Answer, :count)
      end

      it 'render related question view' do
        delete :destroy, params: { question_id: question.id, id: answer, format: :js }
        expect(response).to render_template ('questions/show')
      end
    end

  end
end
