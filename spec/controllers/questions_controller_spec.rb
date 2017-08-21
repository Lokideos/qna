require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do    
    let(:questions) { user; create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do      
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do      
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params:{ id: question } }
    
    it 'assigns the requested question to @question' do      
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do 
      expect(assigns(:answer)).to be_a_new(Answer) 
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
    
    it 'renders show view' do      
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for the question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'saves the new question and its association to correct user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end    

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user    
    let(:question2) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @questions' do
        patch :update, params: { id: question2, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question2
      end

      it 'changes question attributes' do
        patch :update, params: { id: question2, question: { title: 'new title', body: 'new body'} }
        question2.reload
        expect(question2.title).to eq 'new title'
        expect(question2.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, params: { id: question2, question: attributes_for(:question) }
        expect(response).to redirect_to question2
      end
    end

    context 'with invalid attributes' do

      it 'does not change question attributes' do
        correct_title = question.title
        correct_body = question.body
        patch :update, params: { id: question, question: { title: 'new title', body: nil } }
        question.reload
        expect(question.title).to eq correct_title
        expect(question.body).to eq correct_body
      end

      it 're-renders edit view' do
        patch :update, params: { id: question2, question: { title: 'new title', body: nil } }
        expect(response).to render_template :edit
      end
    end

    context 'with invalid user' do
      let(:other_user_question) { create(:question, user: user) }

      it 'does not change quesiton attributes' do
        correct_title = other_user_question.title
        correct_body = other_user_question.body
        patch :update, params: { id: other_user_question, question: { title: 'new title', body: 'new body' } }
        other_user_question.reload
        expect(other_user_question.title).to eq correct_title
        expect(other_user_question.body).to eq correct_body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    context 'with valid user signed in' do
    before { controller.stub(:current_user).and_return (user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid user signed in' do    
      it 'not delete question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :index
      end
    end

  end
end
