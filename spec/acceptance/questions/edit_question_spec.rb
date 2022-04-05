require 'acceptance/acceptance_helper'

feature 'edit question', %q{
  In order to fix mistake 
  As ab author of question
  I want to able to edit my question
} do 
  given!(:another_user) { create(:user) }
  given(:user)          { create(:user) }
  given!(:question)     { create(:question, user: user) }

  scenario 'Unathenticated user to trying to edit a question' do   
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated user try to edit other user's question" do 
    log_in(another_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do 
    before do
      log_in(user)
      visit questions_path
    end
    
    scenario 'sees link to Edit' do 
      expect(page).to have_link 'Edit'
    end 

    scenario 'try to edit his question', js: true do 
      click_on 'Edit'
      fill_in 'Title', with: 'edited title'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textfield'
      expect(page).to_not have_selector 'textarea'
    end
  end
end
