require 'acceptance/acceptance_helper'

feature 'add comment', %q{
  In order to clarify information from the author of the question
  As an authenticated user 
  I want to be able to post a comment  
} do
  let(:user)     { create(:user) }
  let!(:question) { create(:question) }

  scenario 'Authenticeted user leaves a comment', js: true do 
    log_in(user)
    visit question_path(question)

    click_on 'Add a comment'
    fill_in 'New comment', with: 'New comment'
    click_on 'Comment'

    expect(page).to have_content 'New comment'
  end

  context 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        log_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add a comment'
        fill_in 'New comment', with: 'New comment'
        click_on 'Comment'
    
        expect(page).to have_content 'New comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment'
      end
    end
  end
end
