require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do 

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question with valid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user creates question with invalid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content '2 errors were found in the data you typed in.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    
    expect(page).to_not have_content 'Ask question'
  end
  
end