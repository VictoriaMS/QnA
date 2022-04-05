require 'acceptance/acceptance_helper'

feature 'delete the answer', %q{
  In order to keep the answers to the question up to date
  As a authenticated user 
  I want to be able to delete my answer
} do 
  let!(:user)         { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question)     { create(:question, user: another_user) }
  let!(:answer)       { create(:answer, user: user, question: question) }

  scenario 'Authenticated user delete own answer' do 
    log_in(user) 
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user delete a non-own answer' do 
    log_in(another_user)
    visit question_path(question)
    
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthenticated user delete question' do 
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end
