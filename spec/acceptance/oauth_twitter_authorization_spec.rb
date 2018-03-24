require_relative 'acceptance_helper'

feature 'Authenticate via twitter', %q{
  In order to get access to web-application asap
  As a user
  I'd like to be able to authorize via my twitter account
} do

  context 'Existing user' do
    given(:twitter_user) { create(:user) }

    context 'User already has authorization' do     
      given!(:twitter_authorization) { create(:authorization, user: twitter_user, provider: 'twitter', uid: '1234567') }

      scenario 'Tries to autheticate using his twitter account' do
        visit new_user_session_path
        expect(page).to have_link "Sign in with Twitter"

        mock_auth_twitter_hash
        click_link "Sign in with Twitter"
        expect(page).to have_content "Successfully authenticated from Twitter account."
      end

      scenario 'Tries to authenticated with invalid credentials' do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
        visit new_user_session_path
        expect(page).to have_link "Sign in with Twitter"

        click_link "Sign in with Twitter"
        expect(page).to have_content "Invalid credentials"
      end
    end

    context "User didn't authorize via twitter yet" do
      scenario 'Tries to authenticate using his twitter account' do
        visit new_user_session_path
        expect(page).to have_link "Sign in with Twitter"

        mock_auth_twitter_hash
        click_link "Sign in with Twitter"
        expect(page).to have_content "Successfully authenticated from Twitter account."
      end
      scenario 'Tries to authenticate with invalid credentials'
    end
  end

  context 'New user' do
    scenario 'Tries to authenticate using his twitter account'
    scenario 'Tries to authenticate with invalid credentials'
  end
end