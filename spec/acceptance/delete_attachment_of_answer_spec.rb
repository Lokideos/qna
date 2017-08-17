require_relative 'acceptance_helper'

feature "Delete answer's attachment", %q{
  In order to delete excessive details of the answer
  As answer's author
  I'd like to be able to delete my answer's attachments
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author)}
  given!(:attachment) { create(:attachment, attachable: answer)}

  scenario "Non-authenticated user tries to delete answer's attachment", js: true do
    visit question_path(question)

    expect(page).to_not have_content "Edit"
  end

  context "Authenticated User" do
    given(:non_author) { create(:user) }

    scenario "tries to delete attachment from his answer", js: true do
      sign_in(author)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on "Edit"
        click_on "remove attachment"
        click_on "Create Answer"          
      end

      expect(page).to_not have_content attachment.file.identifier
    end

    scenario "tries to delete attachment from other user's answer", js: true do
      sign_in(non_author)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to_not have_content "Edit"
      end
    end
  end
end