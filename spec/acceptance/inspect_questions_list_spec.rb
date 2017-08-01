require 'rails_helper'

feature 'Inspect question list', %q{
  In order to answer to specific question
  As an User
  I want to be able to check questions' list
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user check questions list' do
    sign_in(user)
    question
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated user check questions list' do
    sign_in(user)
    question
    click_on "Sign Out"
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content question.title
  end
  
end

