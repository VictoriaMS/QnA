module AcceptanceMacros
  def log_in(user)
    user.confirm
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def create_answer(question)
    visit question_path(question)
    fill_in 'Body', with: 'answer'
    click_on 'Create Answer'
  end
end
