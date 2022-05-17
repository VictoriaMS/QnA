require 'acceptance/acceptance_helper'

feature 'Sig in via Twitter', %q{
  In order to sign in without email and password
  As an user 
  I want to be able to sign in via Twitter
} do 
  let!(:user) { create(:user) }

  background do 
    twitter_mock_auth_hash
  end

  scenario 'User try to sign in with Twitter' do 
    user.confirm
    user.authorizations.create(provider: twitter_mock_auth_hash.provider  , uid: twitter_mock_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  context 'User try to sign up with Twitter without email' do 
    scenario 'The user sees an email input form' do 
      visit new_user_session_path
      click_on 'Sign in with Twitter'
  
      expect(page).to have_content 'Please enter your email to continue'
      expect(page).to have_field('Email')
    end

    scenario 'The user successfully confirms the mail' do 
      clear_emails
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: 'user@gmail.com'
      click_on 'Сonfirm'

      open_email('user@gmail.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  scenario 'An unverified user is trying to sig in' do 
    user.authorizations.create(provider: twitter_mock_auth_hash.provider  , uid: twitter_mock_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'You need to confirm email'
  end 
end
