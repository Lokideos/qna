require "rails_helper"

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated User
  I want to be able to create answers
} do

  given(:user){ create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Add New Answer', with: 'My answer'
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do 
      expect(page).to have_content 'My answer'
    end
    expect(page).to have_content 'Answer was created'
  end

  scenario 'Authenticated user creates answer with invalid parameters', js: true do 
    sign_in(user)
    visit question_path(question)

    fill_in "Add New Answer", with: nil
    click_on 'Create Answer'

    expect(page).to have_content "Data for your answer contained 1 error: Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer', js: true do
    visit question_path(question)
        
    expect(page).to have_content 'You have to log in to the system to be able to create answers.'
  end

end
