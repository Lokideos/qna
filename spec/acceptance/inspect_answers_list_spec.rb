require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Inspect answers list', %q{
  In order to check answers to the question
  As an User
  I want to be able to check answers' list to question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, user: user, question: question) }

  scenario 'Authenticated user check answers list', js: true do
    sign_in(user)    
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('MyText', count: 3)
    answers.each do |answer|
      expect(page).to have_content answer.body
      expect(page).not_to have_content(answer.body, count: 2)
    end
  end

  scenario 'Non-authenticated user check answers list', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('MyText', count: 3)
    answers.each do |answer|
      expect(page).to have_content answer.body
      expect(page).not_to have_content(answer.body, count: 2)
    end
  end
  
end
