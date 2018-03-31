require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = mock_auth_facebook_hash
  end

  describe 'GET|POST oauth #facebook' do
    before { get :facebook, params: { omniauth_auth: request.env["omniauth.auth"] } }

    it 'assigns the found user to correct class' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET|POST oauth #twitter' do
    before { get :twitter, params: { omniauth_auth: request.env["omniauth.auth"] } }    

    it 'assigns the found user to correct class' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
