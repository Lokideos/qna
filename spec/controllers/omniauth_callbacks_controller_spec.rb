require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  # before do
  #   Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
  #   Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  # end
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = mock_auth_facebook_hash
  end

  describe 'GET|POST omniauth #facebook' do
    before { get :facebook, params: { omniauth_auth: request.env["omniauth.auth"] } }

    it "assigns user from omniauth hash to @user" do
      expect(assigns(:user)).to be_a(User)
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET|POST omniauth #twitter' do
    before { get :twitter, params: { omniauth_auth: request.env["omniauth.auth"] } }

    it "assigns user from omniauth hash to @user" do
      expect(assigns(:user)).to be_a(User)
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end
end