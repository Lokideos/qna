require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I want to be able to edit my answer
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Non-authenticated user tries to edit the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'see link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit the answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Create Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      
    end
  end  

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(non_author)
    visit question_path(question)
    save_and_open_page
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end