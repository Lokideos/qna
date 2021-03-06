require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:id) { question.id }
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      let(:attachment) { attachments.first }

      before { get "/api/v1/questions/#{id}", params: { format: :json, access_token: access_token.token } }

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("short_title")
      end

      context 'comments' do
        it 'contains comments' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/1/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains attachments' do
          expect(response.body).to have_json_size(2).at_path("attachments")
        end

        %w(file).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/1/#{attr}")
          end
        end

        %w(id created_at updated_at).each do |attr|
          it "does not contain #{attr}" do
            expect(response.body).to_not have_json_path("attachments/1/#{attr}")
          end
        end
      end

      it 'does not include answer in question' do
        expect(response.body).to_not have_json_path("answers")
      end
    end

    def do_request(options = {} )
      get "/api/v1/questions/#{id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'creates a question' do
        expect { post_question_create_request }.to change(Question, :count).by(1)
      end

      it 'returns the question' do
        post_question_create_request
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post_question_create_request
          expect(response.body).to be_json_eql(assigns(:question).send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end

    def do_request(options = {} )
      post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }.merge(options)
    end
  end

  private

  def post_question_create_request
    post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, 
                                                          access_token: access_token.token }
  end
end