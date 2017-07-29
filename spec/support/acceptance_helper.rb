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

  # Fabric didn't help because of testing current_user.id method
  def create_question    
    visit questions_path
    
    click_on "Ask question"
    fill_in "Title", with: "My Test Question"
    fill_in "Body", with: "Text text text"
    click_on "Create"
  end

  def create_answer
    fill_in "Add New Answer", with: "My Test Answer"
    click_on "Create Answer"
  end
end