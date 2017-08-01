require 'rails_helper'

feature 'Delete questions only by author', %q{
  To keep my questions
  As user
  I want to be able to delete only mine questions
} do

  given(:user){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user: user) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)
    question
    visit questions_path
    expect(page).to have_content question.title
    click_on "Delete"    

    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete not his question' do        
    question
    sign_in(user2)
    
    visit questions_path
    expect(page).to have_content question.title 
    expect(page).to_not have_content "Delete"
  end

  scenario 'Non-authenticated user tries to delete question' do    
    question
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete"
  end

end