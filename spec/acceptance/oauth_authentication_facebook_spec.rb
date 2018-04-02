require_relative 'acceptance_helper'

feature 'Authenticate via facebook', %q{
  In order to speed up getting access to site
  As a user
  I'd like to be able to authenticate on the site using my facebook account
} do
  given(:user) { create(:user) }

  context 'User & authorization exist' do
    given!(:authorization) { create(:authorization, user: user, provider: 'facebook', uid: '123456') }

    scenario 'User already has authorization' do
      visit new_user_session_path
      expect(page).to have_link ("Sign in with Facebook")

      mock_auth_facebook_hash
      click_link "Sign in with Facebook" 
      expect(page).to have_content "Successfully authenticated from Facebook account."
      expect(current_path).to eq root_path
    end
  end

  context "User doesn't have authorization" do
    scenario "user already exists" do
      user
      visit new_user_session_path
      expect(page).to have_link ("Sign in with Facebook")

      mock_auth_facebook_hash
      click_link 'Sign in with Facebook'
      expect(page).to have_content "Successfully authenticated from Facebook account."
      expect(current_path).to eq root_path
    end

    scenario "user doesn't exist" do
      visit new_user_session_path
      expect(page).to have_link ("Sign in with Facebook")

      mock_auth_facebook_hash
      click_link 'Sign in with Facebook'
      expect(page).to have_content "Successfully authenticated from Facebook account."
      expect(current_path).to eq root_path
    end
  end

  scenario "User tries to authenticate with invalid credentials" do
    visit new_user_session_path
    expect(page).to have_link "Sign in with Facebook"

    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_link "Sign in with Facebook"   
    expect(page).to have_content "Invalid credentials"
  end
end