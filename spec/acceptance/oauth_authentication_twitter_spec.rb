require_relative 'acceptance_helper'

feature 'Authenticate via twitter', %q{
  In order to get access to site faster
  As a user
  I'd like to be able to authenticate using my twitter account
} do
  given(:user) { create(:user) }

  context 'User exists and has authorization' do
    given!(:authorization) { create(:authorization, user: user, provider: 'twitter', uid: '12345') }

    scenario 'User tries to authenticate via his tiwtter account' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Twitter'

      mock_auth_twitter_hash
      click_link "Sign in with Twitter"
      expect(page).to have_content "Successfully authenticated from Twitter account."
      expect(current_path).to eq root_path
    end
  end

  context 'There is no authorization' do
    scenario 'User exists & tries to authenticate via his twitter account' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Twitter'

      mock_auth_twitter_hash
      click_link "Sign in with Twitter"        
      expect(page).to have_content "Email search"
      expect(current_path).to eq find_email_email_oauth_assigner_path

      fill_in 'Email', with: user.email
      click_on "Search for email"
      expect(page).to have_content "You email was found"
      expect(current_path).to eq check_email_email_oauth_assigner_path

      fill_in 'Password', with: user.password
      click_on "Confirm email"
      expect(page).to have_content "Successfully authenticated from Twitter account."
      expect(current_path).to eq root_path
    end

    scenario 'User does not exist & tries to authenticate via his twitter account' do
      visit new_user_session_path
      expect(page).to have_link 'Sign in with Twitter'

      mock_auth_twitter_hash
      click_link "Sign in with Twitter"        
      expect(page).to have_content "Email search"
      expect(current_path).to eq find_email_email_oauth_assigner_path

      fill_in 'Email', with: "newemail@example.com"
      click_on "Search for email"
      expect(page).to have_content "Please confirm your address"
      
      open_email "newemail@example.com"
      current_email.click_link "Confirm my account"
      expect(page).to have_content "You've been successfully authenticated"
      expect(current_path).to eq root_path
    end  
  end

  context 'User tries to authenticate using invalid credentials' do
    scenario 'User tries to authenticate via his tiwtter account' do
      visit new_user_session_path
      expect(page).to have_link "Sign in with Twitter"

      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_link "Sign in with Twitter"   
      expect(page).to have_content "Invalid credentials"
    end
  end
end