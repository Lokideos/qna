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

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated user check questions list' do
    Question.create!(title: question.title, body: question.body)

    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content question.title
  end
  
end

