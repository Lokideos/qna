require "rails_helper"

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated User
  I want to be able to create answers
} do

  given(:user){ create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Add New Answer', with: 'My answer'
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do 
      expect(page).to have_content 'My answer'
    end
  end

end