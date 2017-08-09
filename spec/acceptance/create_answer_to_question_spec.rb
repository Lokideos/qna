require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Create answer to question', %q{
  In order to answer to question
  As User
  I want to create answers to this question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer with valid parameters' do
    sign_in(user)
    visit question_path(question)
    
    fill_in "Add New Answer", with: 'Test Answer'
    click_on 'Create Answer'

    expect(page).to have_content 'Test Answer'
    expect(page).to have_content 'Answer was created.'    
  end

  scenario 'Authenticated user creates answer with invalid parameters' do
    sign_in(user)
    visit question_path(question)

    fill_in "Add New Answer", with: nil
    click_on 'Create Answer'

    expect(page).to have_content "Data for your answer contained 1 error: Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
        
    expect(page).to have_content 'You have to log in to the system to be able to create answers.'
  end

end
