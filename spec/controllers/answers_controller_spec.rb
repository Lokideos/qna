require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

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
    let(:answer_current_user) { create(:answer, user: @user, question: question)}

    context 'with valid attributes' do
      it 'assigns the requestesd answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer_current_user
      end

      it 'assigns the right question' do
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'assigns the right user' do
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: { user: @user }, format: :js }
        expect(answer_current_user.user).to eq @user
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: { body: 'new body' }, format: :js }
        answer_current_user.reload
        expect(answer_current_user.body).to eq 'new body'
      end

      it 'render update template' do        
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change answer attributes' do
        correct_body = answer_current_user.body
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: { body: nil }, format: :js }
        answer_current_user.reload
        expect(answer_current_user.body).to eq correct_body
      end

      it 'render update template' do
        patch :update, params: { question_id: question.id, id: answer_current_user, answer: { body: nil }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid user' do
      let(:other_user_answer) { create(:answer, question_id: question.id, user: user) }

      it 'does not change answer attributes' do
        correct_body = other_user_answer.body
        patch :update, params: { question_id: question, id: other_user_answer, answer: { body: 'wrong body' }, format: :js }
        expect(other_user_answer.body).to eq correct_body
      end
    end
  end

  # describe 'DELETE #destroy' do
  #   sign_in_user

  #   before { answer }

  #   context 'with valid author' do
  #     before { controller.stub(:current_user).and_return (user) }

  #     it 'deletes answer' do
  #       expect { delete :destroy, params: { question_id: question.id, id: answer, format: :js } }.to change(question.answers, :count).by(-1)
  #     end

  #     it 'render related question view' do
  #       delete :destroy, params: { question_id: question.id, id: answer, format: :js }
  #       expect(response).to redirect_to question_path(assigns(:question))        
  #     end
  #   end
    
  #   context 'with invalid author' do

  #     it 'not deletes answer' do
  #       expect { delete :destroy, params: { question_id: question.id, id: answer, format: :js } }.not_to change(Answer, :count)
  #     end

  #     it 'render related question view' do
  #       delete :destroy, params: { question_id: question.id, id: answer, format: :js }
  #       expect(response).to render_template ('questions/show')
  #     end
    # end

  # end
end
