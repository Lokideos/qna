require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { question_id: question.id, id: answer } }

    it 'assign the requested answer to @answer' do      
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do      
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    before { controller.stub(:current_user).and_return (user) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)        
      end

      it 'saves the new answer and its association to correct user' do
        post :create, params: { question_id: question.id, answer:attributes_for(:answer) }
        expect(assigns(:answer).user_id).to eq user.id
      end

      it 'saves the new answer and its association to correct question' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to question show view with success flash notice' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'redirects to question show view with error flash notice' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

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
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      before do
        answer
        @correct_body = answer.body
        patch :update, params: { question_id: question.id, id: answer, answer: { body: nil } }         
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq @correct_body
      end

      it 'redirect to related quesiton view and show flash error message' do
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { answer }

    context 'with valid author' do
      before { controller.stub(:current_user).and_return (user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to related question view' do
        delete :destroy, params: { question_id: question.id, id: answer }
        expect(response).to redirect_to question_path(assigns(:question))        
      end
    end
    
    context 'with invalid author' do

      it 'not deletes answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to related question view' do
        delete :destroy, params: { question_id: question.id, id: answer }
        expect(response).to redirect_to question_path(assigns(:question))        
      end
    end

  end
end
