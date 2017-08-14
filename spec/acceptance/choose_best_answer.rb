require_relative 'acceptance_helper'

feature 'Choose Best answer', %q{
  In order to rate right answer
  As a User
  I want to be able to choose one answer as best answer
} do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }
  given!(:answer3) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user tries to choose best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link "Best Answer"
  end
  
  scenario 'Authenticated user see best answer link', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link "Best Answer"
    end
  end

  scenario 'Authenticated user tries to choose best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer-3' do
      click_on "Best Answer"
    end

    within '.best-answer' do
      expect(page).to have_content answer3.body
    end
  end

  scenario 'Authenticated user tries to choose another best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer-3' do
      click_on "Best Answer"
    end

    within '.answer-2' do
      click_on "Best Answer"
    end

    within '.best-answer' do
      expect(page).to_not have_content answer3.body
      expect(page).to have_content answer2.body
    end
  end

  scenario 'Authenticated user tries to choose best answer of another users question', js: true do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_link "Best Answer"
  end
    
end