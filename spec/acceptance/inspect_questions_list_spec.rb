require 'rails_helper'

feature 'Inspect question list', %q{
  In order to answer to specific question
  As an User
  I want to be able to check questions' list
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:questions) { create_list(:question, 3, user: user) }

  scenario 'Authenticated user check questions list' do
    sign_in(user)
    questions
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content('Test Question', count: 3)
  end

  scenario 'Non-authenticated user check questions list' do
    questions
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content('Test Question', count: 3)
  end
  
end
