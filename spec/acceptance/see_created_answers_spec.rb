require_relative 'acceptance_helper'

feature 'see created answer', %q{
    In order to keep an eye on interesting topic
    As a user
    I want to be able to check new answers without updating the web page
  }, :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context "multiple sessions" do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add New Answer', with: 'My answer'
        click_on 'Create Answer'

        expect(current_path).to eq question_path(question)
        within '.answers' do 
          expect(page).to have_content 'My answer'
        end
        expect(page).to have_content 'Answer was created'
      end

      Capybara.using_session('guest') do
        within '.answers' do 
          expect(page).to have_content 'My answer'
        end
      end
    end
  end
end