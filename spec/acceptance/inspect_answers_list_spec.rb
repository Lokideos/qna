require 'rails_helper'

feature 'Inspect answers list', %q{
  In order to check answers to the question
  As an User
  I want to be able to check answers' list to question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:answers) { create_list(:answer, 3, user: user, question: question) }

  scenario 'Authenticated user check answers list' do
    sign_in(user)
    question    
    answers
    visit question_path(question)
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('MyText', count: 3)
  end

  scenario 'Non-authenticated user check answers list' do    
    question
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('MyText', count: 3)
  end
  
end

