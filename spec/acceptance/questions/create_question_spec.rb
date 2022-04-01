require 'acceptance/acceptance_helper'

feature 'create question', %q{ 
  In order to get anwer from community
  As an authenticated user
  I want to be able to ask questions
  } do 
  given(:user) { create(:user) }
  
  scenario 'Authenticated user creates a question' do 
    log_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'Body question'
    click_on 'Create'


    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_text 'Title question'
    expect(page).to have_text 'Body question'
  end

  scenario 'Authenticated user creates a question with invalid attributes' do 
    log_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user creates a question' do 
    visit questions_path
    click_on 'Ask question'
     
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
