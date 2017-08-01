require 'rails_helper'

feature 'Create answer to question', %q{
  In order to answer to question
  As User
  I want to create answers to this question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates answer with valid parameters' do
    sign_in(user)
    create_question

    visit questions_path
    click_on 'Show'    
    
    fill_in "Add New Answer", with: 'Test Answer'
    click_on 'Create Answer'

    expect(page).to have_content 'Test Answer'
    expect(page).to have_content 'Answer was created.'    
  end

  scenario 'Authenticated user creates answer with invalid parameters' do
    sign_in(user)
    create_question

    visit questions_path
    click_on 'Show'

    fill_in "Add New Answer", with: nil
    click_on 'Create Answer'

    expect(page).to have_content "Data for your answer contained 1 error: Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do
    sign_in(user)
    create_question    
    click_on 'Sign Out'

    
    visit questions_path
    click_on 'Show'    

    expect(page).to have_content 'You have to log in to the system to be able to create answers.'
  end

end
