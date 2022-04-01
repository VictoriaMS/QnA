require 'acceptance/acceptance_helper'

feature 'create answer', %q{
  In order to share knowledge and help another user
  As an user 
  I want to be able to create an answer to a question
} do 
  let!(:question) { create(:question) }
  let!(:user)     { create(:user) }

  scenario 'Authenticated user creates an answer', js: true do
    log_in(user)
    create_answer(question)
    
    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'answer'
    end
  end

  scenario 'Anthenticated user creates an answer with invalid attributes', js: true do 
    log_in(user) 
    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user creates a question' do 
    create_answer(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
