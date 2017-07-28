require 'rails_helper'

feature 'Create answer to question', %q{
  In order to answer to question
  As User
  I want to create answers to this question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create answer' do
    sign_in(user)
    create(:question)

    visit questions_path
    click_on 'Show'
    
    fill_in "Add New Answer", with: 'Test Answer'
    click_on 'Create'

    expect(page).to have_content 'Test Answer'
  end

  scenario 'Non-authenticated user tries to create answer' do
    create(:question)
    visit questions_path
    click_on 'Show'
    save_and_open_page
    
    expect(page).to have_content 'You have to log in to the system to be able to create answers.'
  end

end
