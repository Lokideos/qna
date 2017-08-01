require 'rails_helper'

feature 'Delete answers only by author', %q{
  To keep my answers
  As user
  I want to be able to delete only mine answers and questions
} do

  given(:user){ create(:user) }
  given(:user2){ create(:user) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user)

    create_question

    create_answer

    click_on "Delete"
    expect(page).to_not have_content "My Test Answer"
  end
  
  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(user)

    create_question

    create_answer

    click_on "Sign Out"
    sign_in(user2)

    click_on "Show"
    
    expect(page).to_not have_content "Delete" 
  end
  
  scenario 'Non-authenticated user tries to delete answer' do
    sign_in(user)

    create_question

    create_answer

    click_on "Sign Out"

    click_on "Show"
    expect(page).to_not have_content "Delete"
  end

end