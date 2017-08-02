require 'rails_helper'

feature 'Delete answers only by author', %q{
  To keep my answers
  As user
  I want to be able to delete only mine answers
} do

  given!(:user){ create(:user) }
  given!(:user2){ create(:user) }
  given!(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user)    
    visit question_path(question)
    expect(page).to have_content answer.body

    click_on "Delete"
    expect(page).to_not have_content answer.body
  end
  
  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(user2)
    
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content "Delete" 
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)
        
    expect(page).to have_content answer.body
    expect(page).to_not have_content "Delete"
  end

end