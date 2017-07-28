module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def start_registration
    visit root_path
    click_on "Sign In"
    click_on "Sign up"
  end
end