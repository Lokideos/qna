require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Inspect question list', %q{
  In order to answer to specific question
  As an User
  I want to be able to check questions' list
} do 

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'Authenticated user check questions list' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content('Test Question', count: 3)
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).not_to have_content(question.title, count: 2)
    end
  end

  scenario 'Non-authenticated user check questions list' do
    visit questions_path

    expect(page).to have_content "Questions List"
    expect(page).to have_content('Test Question', count: 3)
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).not_to have_content(question.title, count: 2)
    end
  end
  
end
