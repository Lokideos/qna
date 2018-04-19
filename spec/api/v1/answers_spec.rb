require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1/answers/1', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/1/answers/1', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let(:question_id) { question.id }
      let!(:answer) { create(:answer, question: question) }
      let(:answer_id) { answer.id }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let(:attachment) { attachments.first }

      before { get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

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
  end
end