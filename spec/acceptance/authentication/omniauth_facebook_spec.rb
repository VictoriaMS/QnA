require 'acceptance/acceptance_helper'

feature 'Sign in via Facebook', %q{
  In order to sign in without email and password 
  As an user
  I want to be able to sign in via Facebook
} do 

  let!(:user) { create(:user) }

  background do 
    facebook_mock_auth_hash
  end

  scenario 'User try to sign in with Facebook' do 
    user.confirm
    user.authorizations.create(provider: facebook_mock_auth_hash.provider, uid: facebook_mock_auth_hash.uid)

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end

  scenario 'User try sign up with facebook' do 
    clear_emails
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    open_email('test@qna.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
