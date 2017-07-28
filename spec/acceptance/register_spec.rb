require 'rails_helper'

feature 'Sign Up', %q{
  In order to ask questions and add answers
  As User
  I want to be able to sign up
} do

  given(:user){ create(:user) }

  scenario 'Non-existed user tries to sign up' do
    visit root_path
    click_on 'Sign In'

    click_on 'Sign up'    
    fill_in 'Email', with: "test@test.com"
    fill_in 'Password', with: "123456789"
    fill_in 'Password confirmation', with: "123456789"
    click_on 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end

  scenario 'Existed user tries to sign up' do
    visit root_path
    click_on 'Sign In'

    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content "Email has already been taken"
    expect(current_path).to eq user_registration_path
  end

  scenario 'Authenticated user tries to sign up' do
    visit root_path
    sign_in(user)

    expect(page).to_not have_content "Sign In"
  end

end