require 'acceptance/acceptance_helper'

feature 'delete the answer', %q{
  In order to keep the answers to the question up to date
  As a authenticated user 
  I want to be able to delete my answer
} do 
  let!(:user)         { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question)     { create(:question, user: another_user) }
  let!(:answers)      { create_list(:answer, 3, user: another_user, question: question) }
  let!(:answer)       { create(:answer, user: user, question: question) }

  scenario 'Authenticated user delete own answer' do 
    log_in(user) 
    question.reload
    answer.reload
    visit question_path(question)
    find("##{answer.id}").click

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'Authenticated user delete a non-own answer' do 
    log_in(user)
    visit question_path(question)
    find("##{answers.first.id}").click
    
    expect(page).to have_content 'You cannot delete this answer'
    expect(page).to have_content answers.first.body
  end

  scenario 'Unauthenticated user delete question' do 
    visit question_path(question)
    find("##{answer.id}").click

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
