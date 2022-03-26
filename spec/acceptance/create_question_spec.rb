require 'rails_helper'

feature 'create question', %q{ 
  In order to get anwer from community
  As an user
  I want to be able to ask questions
  } do 
  scenario 'User creates a question' do 
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'Body question'
    click_on 'Create'


    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_text 'Title question'
    expect(page).to have_text 'Body question'
  end
end
