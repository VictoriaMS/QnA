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
     
    expect(page).to_not have_link 'Ask question'
  end

  context 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        log_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: 'Body question'
        click_on 'Create'
  
        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_text 'Title question'
        expect(page).to have_text 'Body question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Title question'
      end
    end
  end
end
