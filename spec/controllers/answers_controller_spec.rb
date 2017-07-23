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

end
