require 'rails_helper'

feature 'user log in', %q{
  In order to be able to ask question 
  As an user 
  I want to be able to log in
} do
  given(:user) { create(:user) }

  scenario 'registered user try to log in' do 
    log_in(user)
   
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to log in' do 
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end
