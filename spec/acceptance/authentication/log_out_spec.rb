require 'acceptance/acceptance_helper'

feature 'user log out', %q{
  In order ensure the security of personal data
  As a authenticated user
  I want to able to log out
} do 
  given(:user) { create(:user) }
  scenario 'authenticated user log out' do 
    log_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
