require 'acceptance/acceptance_helper'

feature 'delete the question', %q{
  In order to receive answers only to relevant questions
  As a authenticated user 
  I want to be able to delete my questions
} do 
  given(:user)         { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question)    { create(:question, user: user) }
  given!(:questions)   { create_list(:question, 3, user: another_user) }

  scenario 'Authenticated user delete own question' do 
    log_in(user) 
    visit questions_path
    find("##{question.id}").click

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'Question successfully deleted'
  end

  scenario 'Authenticated user delete a non-own question' do 
    log_in(user)
    visit questions_path
    find("##{questions.first.id}").click
    
    expect(page).to have_content 'You cannot delete this question.'
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.first.body
  end

  scenario 'Unauthenticated user delete question' do 
    visit questions_path
    find("##{question.id}").click
    
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
