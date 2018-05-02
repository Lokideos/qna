require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:question_id) { question.id }
    let!(:answer) { create(:answer, question: question) }
    let(:answer_id) { answer.id }
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let(:attachment) { attachments.first }

      before { get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json, access_token: access_token.token } }

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
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
      get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    let(:question) { create(:question) }
    let(:question_id) { question.id }
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:answer) { answers.first }

      before { get "/api/v1/questions/#{question_id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'contains answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {} )
      get "/api/v1/questions/#{question_id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }
    let(:id) { question.id }
    it_behaves_like "API Authenticalble"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'creates an answer' do
        expect { post_answer_create_request }.to change(Answer, :count).by(1)
      end

      it 'returns the answer' do
        post_answer_create_request
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at question_id user_id).each do |attr|
        it "contains #{attr}" do
          post_answer_create_request
          expect(response.body).to be_json_eql(assigns(:answer).send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end

    def do_request(options = {} )
      post "/api/v1/questions/#{id}/answers", params: { answer: attributes_for(:answer), question: question, format: :json }.merge(options)
    end
  end

  private

  def post_answer_create_request
    post "/api/v1/questions/#{id}/answers", params: { answer: attributes_for(:answer), question: question, 
                                                          format: :json, access_token: access_token.token }
  end
end