require 'rails_helper'

feature 'Sign out', %q{
  In order to answer as another person
  As authenticated user
  I want to be able sign out
} do
  given(:user){ create(:user) }

  scenario "Registered user is able to sign out" do
    sign_in(user)

    expect(page).to have_content "Sign Out"
  end

  scenario "Registered user tries to sign out" do
    sign_in(user)

    click_on "Sign Out"

    expect(page).to have_content "Signed out successfully."
  end
end