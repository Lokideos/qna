require 'rails_helper'
require_relative 'acceptance_helper'

feature 'Sign out', %q{
  In order to answer as another person
  As authenticated user
  I want to be able sign out
} do
  given(:user){ create(:user) }

  scenario "Registered user is able to sign out" do
    sign_in(user)

    expect(page).to have_content "Sign Out"

    click_on "Sign Out"
    expect(page).to have_content "Signed out successfully."
  end

  scenario "Non-logged in user tries to sign out" do
    visit root_path

    expect(page).not_to have_content "Sign Out"    
  end
end