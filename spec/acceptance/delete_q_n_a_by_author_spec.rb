require 'rails_helper'

feature 'Delete questions and answers only by author', %q{
  In keep my answers and questions
  As user
  I want to be able to delete only mine answers and questions
} do

  given(:user){ create(:user) }  

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)
    visit questions_path
    
    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    visit questions_path
    click_on "Delete"    

    expect(page).to_not have_content "My Test Question"
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user)
    visit questions_path
    
    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    fill_in "Add New Answer", with: "My Test Answer"
    click_on "Create Answer"

    click_on "Delete"
    expect(page).to_not have_content "My Test Answer"
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(user)
    visit questions_path

    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    click_on "Sign Out"
    create(:user)
    sign_in(user)
    click_on "Delete"
    
    expect(page).to have_content "My Test Question"
  end

  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(user)
    visit questions_path

    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    fill_in "Add New Answer", with: "My Test Answer"
    click_on "Create Answer"

    click_on "Sign Out"
    create(:user)
    sign_in(user)
    click_on "Show"
    click_on "Delete"
    expect(page).to have_content "My Test Answer"    
  end

  scenario 'Non-authenticated user tries to delete question' do
    sign_in(user)
    visit questions_path

    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    click_on "Sign Out"

    expect(page).to_not have_content "Delete"
  end

  scenario 'Non-authenticated user tries to delete answer' do
    sign_in(user)
    visit questions_path

    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"

    fill_in "Add New Answer", with: "My Test Answer"
    click_on "Create Answer"

    click_on "Sign Out"

    click_on "Show"
    expect(page).to_not have_content "Delete"
  end

end