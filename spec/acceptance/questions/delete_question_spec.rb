require 'acceptance/acceptance_helper'

feature 'delete the question', %q{
  In order to receive answers only to relevant questions
  As a authenticated user 
  I want to be able to delete my questions
} do 
  given(:user)         { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question)    { create(:question, user: user) }

  scenario 'Authenticated user delete own question' do 
    log_in(user) 
    visit questions_path
    click_on 'Destroy'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Authenticated user delete a non-own question' do 
    log_in(another_user)
    visit questions_path
 
    expect(page).to_not have_link 'Destroy'
  end

  scenario 'Unauthenticated user delete question' do 
    visit questions_path
    
    expect(page).to_not have_link 'Destroy'
  end
end
