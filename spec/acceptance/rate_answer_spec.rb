require_relative 'acceptance_helper'

feature 'Rate answer', %q{
  In order to choose useful answers to question
  As a Authenticate user
  I'd like to be able to rate answers
} do
  given(:author){ create(:user) }
  given(:question){ create(:question, user: author) }
  given!(:answer){ create(:answer, question: question, user: author) }

  context 'Authenticated user' do
    given(:non_author){ create(:user) }

    scenario "tries to rate other user's answer", js: true do
      sign_in(non_author)
      visit question_path(question)

      within '.answers' do
        click_on 'Good Answer'

        expect(page).to have_content "Answer Rating: 1"
      end
    end
    scenario "tries to rate his answer"
  end

  scenario "Non-authenticated user tries to rate answer", js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content "Good Answer"
    end
  end
end
