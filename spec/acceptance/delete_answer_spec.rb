require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Delete answers only by author', %q{
  To keep my answers
  As user
  I want to be able to delete only mine answers
} do

  given(:author){ create(:user) }
  given(:non_author){ create(:user) }
  given(:question){ create(:question, user: author) }
  given!(:answer){ create(:answer, question: question, user: author) }

  scenario 'Authenticated user tries to delete his answer', js: true do
    sign_in(author)    
    visit question_path(question)

    click_on "Delete Answer"
    expect(page).to_not have_content answer.body
  end
  
  scenario 'Authenticated user tries to delete not his answer', js: true do
    sign_in(non_author)
    visit question_path(question)
    
    expect(page).to_not have_content "Delete Answer" 
  end

  scenario 'Non-authenticated user tries to delete answer', js: true do
    visit question_path(question)
    
    expect(page).to_not have_content "Delete Answer"
  end

end