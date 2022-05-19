require 'acceptance/acceptance_helper'

feature 'admin edit answer', %q{
  In order to fix mistake
  As admin
  I want to able to edit any answer
} do 
  let!(:admin)    { create(:admin) }
  let!(:question) { create(:question) }

  context 'admin answer' do 
    let!(:admin_answer) { create(:answer, user: admin, question: question) }
    scenario 'Admin to edit answer', js: true do 
      log_in(admin)
      visit question_path(question) 

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content admin_answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  context 'user answer' do 
    let!(:user_answer) { create(:answer, question: question) }
    scenario 'Admin edit answer', js: true do 
      log_in(admin) 
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content user_answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end      
    end
  end
end
