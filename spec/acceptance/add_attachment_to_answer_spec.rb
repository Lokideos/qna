require_relative 'acceptance_helper'

feature "Add attachment to answer", %q{
  In order to clarify answer to question
  As answer's author
  I'd like to be able to add attachments to answer
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }  

  context "For new Answer" do
    scenario "Non-authenticated user tries to add attachment", js: true do
      visit question_path(question)

      expect(page).to_not have_content "File"
    end

    scenario "Authenticated user tries to add attachment", js: true do
      sign_in(author)
      visit question_path(question)

      within ".post_new_answer" do
        fill_in "Add New Answer", with: "Test Answer Body"
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
        click_on "Create Answer"
      end

      within ".answers" do
        expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      end
    end
  end

  context "For existing Answer" do
    scenario "Non-authenticated user tries to add attachment", js: true do
      visit question_path(question)

      expect(page).to_not have_content "File"
    end

    context "Authenticated user" do
      scenario "tries to add attachment to his answer"
      scenario "tries to add attachment to other's user answer"
    end
  end
end