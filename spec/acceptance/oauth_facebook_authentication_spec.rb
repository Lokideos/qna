require_relative 'acceptance_helper'

feature "Authenticate via facebook", %q{
  In order to faster get access to the web-site
  As a user
  I'd like to be able to authorize on the site via my facebook account
} do

  context "Existing user" do
    given(:user) { create(:user) }   
    
    scenario "Tries to autheticate via his facebook account" do
      visit new_user_session_path
      expect(page).to have_link "Sign in with Facebook"

      mock_auth_facebook_hash
      click_on "Sign in with Facebook"
      expect(page).to have_content "Successfully authenticated from Facebook account."
    end

    scenario "Tries to autheticate via facebook with invalid credentials" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_link "Sign in with Facebook"
      
      click_on "Sign in with Facebook"
      expect(page).to have_content "Invalid credentials"
    end
  end

  context "New user" do
    scenario "Tries to authenticate via his facebook account" do
      visit new_user_session_path
      expect(page).to have_link "Sign in with Facebook"

      mock_auth_facebook_hash
      click_on "Sign in with Facebook"
      expect(page).to have_content "Successfully authenticated from Facebook account."
    end

    scenario "Tries to autheticate via facebook with invalid credentials" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_link "Sign in with Facebook"

      click_on "Sign in with Facebook"
      expect(page).to have_content "Invalid credentials"
    end
  end
end