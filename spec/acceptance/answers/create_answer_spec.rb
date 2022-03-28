require 'rails_helper'

feature 'create answer', %q{
  In order to share knowledge and help another user
  As an user 
  I want to be able to create an answer to a question
} do 
  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  scenario 'Authenticated user creates a answer' do
    log_in(user) 
    create_answer(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'answer'
  end

  scenario 'Unauthenticated user creates a question' do 
    create_answer(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
