require_relative 'acceptance_helper.rb'

feature 'Rate question', %q{
  In order to choose useful questions
  As a User
  I'd like to be able to rate questions
} do
  given(:author){ create(:user) }
  given(:question){ create(:question, user: author) }

  context "Authenticated user" do
    given (:non_author){ create(:user) }
    scenario "tries to rate other user's question", js: true do
      sign_in(non_author)
      visit question_path(question)

      click_on "Good Question"
      expect(page).to have_content "Question Rating: 1"
    end

    scenario "tries to rate his question", js: true do
      sign_in(author)
      visit question_path(question)

      expect(page).to_not have_content "Good Question"
    end

    scenario "tries to rate other user's question twice", js: true do
      sign_in(non_author)
      visit question_path(question)

      click_on "Good Question"
      expect(page).to have_content "Question Rating: 1"
      expect(page).to_not have_content "Good Question"
    end
  end

  scenario "Non-authenticated user tries to rate question" , js: true do
    visit question_path(question)

    expect(page).to_not have_content "Good Question"
  end
end