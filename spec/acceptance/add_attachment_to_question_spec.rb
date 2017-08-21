require_relative 'acceptance_helper'

feature "Add attachment to question", %q{
  In order to clarify the question
  As question's author
  I'd like to be able to add attachments to my question
} do
  given(:author) { create(:user) }

  
  
  context "For new question" do
    scenario "Non-authenticated user tries to add attachment to question" do
      visit new_question_path

      expect(page).to_not have_content "File"
    end
    
    scenario "Authenticated user tries to add attachment to his question" do
      sign_in(author)
      visit new_question_path

      fill_in "Title", with: "Test Question"
      fill_in "Body", with: "Test Body"
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
      click_on "Create Question"

      expect(page).to have_link "spec_helper.rb"
    end
  end

  context "For existing question" do
    given(:non_author) { create(:user) }
    given(:question) { create(:question, user: author) }

    scenario "Non-authenticated user tries to add attachment to question" do
      visit edit_question_path(question)

      expect(page).to_not have_content "File"
    end

    context "Authenticated user" do
      scenario "tries to add attachment to his question" do
        sign_in(author)
        visit edit_question_path(question)
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
        click_on "Change Question"

        expect(page).to have_link "spec_helper.rb"
      end

      scenario "tries to add attachment to other user's question" do
        sign_in(non_author)
        visit edit_question_path(question)

        expect(page).to_not have_content "File"
      end
    end
  end

  scenario "Authenticated user tries to add multiplie attachments to new question", js: true do
    sign_in(author)
    visit new_question_path

    fill_in "Title", with: "Test Question"
    fill_in "Body", with: "Test Body"
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add attachment'
    within all('.nested-fields').last do
      attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
    end      

    click_on "Create Question"    
    expect(page).to have_link "spec_helper.rb"
    expect(page).to have_link "rails_helper.rb"
  end  
end