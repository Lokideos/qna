require 'rails_helper'

feature 'Inspect question list', %q{
  In order to answer to specific question
  As an User
  I want to be able to check questions' list
} do 

  given(:user) { create(:user) }

  scenario 'Authenticated user check questions list' do
    sign_in(user)
    Question.create!(title: "Test Question", body: "Test text")

    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content "Test Question"
  end

  scenario 'Non-authenticated user check questions list' do
    visit questions_path

    Question.create!(title: "Test Question", body: "Test text")
    expect(page).to have_content "Questions List"    
    expect(page).to have_content "Test Question"
  end
  
end

