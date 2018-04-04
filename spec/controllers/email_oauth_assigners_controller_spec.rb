require 'rails_helper'

RSpec.describe EmailOauthAssignersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #find_email" do
    before { get :find_email }

    it 'renders find_email template' do   
      expect(response).to render_template :find_email
    end
  end

  describe "POST #check_email"

  describe "POST #assign_oauth_authorization"

end