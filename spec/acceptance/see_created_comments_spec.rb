require_relative 'acceptance_helper'

feature 'see created answer', %q{
    In order to keep an eye on interesting topic
    As a user
    I want to be able to check new comments to answer without updating the page
  } do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context "multiple sessions" do
    scenario "comment to question appears on another user's page", js: true do

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        

        within ".question-comments" do
          click_on "Add Comment"
          fill_in "Your comment", with: "Test comment"
          click_on "Add comment"
        end
        
        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end

    scenario "comment to answer appears on another user's page", js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        
        within ".answers" do
          click_on "Add Comment"
          fill_in "Your comment", with: "Test comment"
          click_on "Add comment"
        end

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end