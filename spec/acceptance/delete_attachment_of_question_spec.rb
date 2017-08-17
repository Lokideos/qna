require_relative 'acceptance_helper'

feature "Delete question's attachment", %q{
  In order to delete excessive details of the question
  As question's author
  I'd like to be able to delete my question's attachments
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:attachment) { create(:attachment, attachable: question)}

  scenario "Non-authenticated user tries to delete question's attachment" do
    visit question_path(question)

    expect(page).to_not have_content "Edit"
  end

  context "Authenticated User" do
    given(:non_author) { create(:user) }

    scenario "tries to delete attachment from his question"  do
      sign_in(author)
      visit edit_question_path(question)      
      within ".attachment-#{attachment.id}" do
        click_on "remove attachment"        
      end
      click_on "Change Question"
      
      expect(page).to_not have_link attachment.file.url
    end

    scenario "tries to delete attachment from other user's question" do
      sign_in(non_author)
      visit edit_question_path(question)

      expect(page).to_not have_content "Change Question"
    end
  end
end