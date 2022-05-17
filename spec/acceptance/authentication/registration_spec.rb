require 'acceptance/acceptance_helper'

feature 'User can register', %q{
  In order to enjoy all the features of the application
  As a authenticated user
  I want to be able to register 
} do 
  given(:user) { create(:user) }

  scenario 'an unauthenticated user is trying to register' do \
    clear_emails
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    open_email('new_user@test.com')
    current_email.click_link('Confirm my account')

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'an authenticated user is trying to register' do 
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'
  end
end
