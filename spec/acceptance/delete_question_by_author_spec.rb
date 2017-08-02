require 'rails_helper'

feature 'Delete questions only by author', %q{
  To keep my questions
  As user
  I want to be able to delete only mine questions
} do

  given!(:author){ create(:user) }
  given!(:non_author){ create(:user) }
  given!(:question){ create(:question, user: author) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(author)
    visit questions_path
    expect(page).to have_content question.title
    click_on "Delete"    

    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(non_author)
    
    visit questions_path
    expect(page).to have_content question.title 
    expect(page).to_not have_content "Delete"
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete"
  end

end