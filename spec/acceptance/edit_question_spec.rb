require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to correct request
  As a user
  I want to be able to edit my question
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'On questions index page' do
    before { visit questions_path }

    scenario 'Non-authenticated user tries to edit question from questions index page' do
      expect(page).to_not have_link 'Edit'
    end

    describe 'Authenticated user' do
      before { sign_in(author) }

      scenario 'see edit link' do        
        expect(page).to have_link 'Edit'
      end

      scenario 'tries to edit his question' do
        click_on 'Edit'
        fill_in "Title", with: "Edited question"
        click_on 'Change Question'

        expect(page).to_not have_content  question.title
        expect(page).to have_content "Edited question"
      end

      scenario "tries to edit other user's question" do
        click_on 'Sign Out'
        sign_in(non_author)

        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'On question page' do
    before { visit question_path(question) }

    scenario 'Non-authenticated user tries to edit question from question page' do
      expect(page).to_not have_link 'Edit'
    end

    describe 'Authenticated user' do
      before { sign_in(author) }

      scenario 'see edit link' do
        expect(page).to have_link 'Edit'
      end

      scenario 'tries to edit his question' do
        click_on 'Edit'
        fill_in "Title", with: "Edited question"
        click_on 'Change Question'

        expect(page).to_not have_content  question.title
        expect(page).to have_content "Edited question"
      end

      scenario "tries to edit other user's question" do
        click_on 'Sign Out'
        sign_in(non_author)
        visit question_path(question)

        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
