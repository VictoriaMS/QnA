require 'acceptance/acceptance_helper'

feature 'admin delete answer', %q{
  In order to keep the answers to the question up to date 
  As an admin 
  I want to be able to delete any answer
} do 
  let!(:admin) { create(:admin) }
  let!(:question)     { create(:question) }

  context 'admin answer' do 
    let!(:admin_answer) { create(:answer, user: admin, question: question) }

    scenario 'admin delete answer', js: true do
      log_in(admin)
      visit question_path(question)

      within '.answers' do
        click_on 'Delete answer'
        expect(page).to_not have_content admin_answer.body
      end
    end
  end

  context 'user answer' do 
    let!(:user_answer) { create(:answer, question: question) }

    scenario 'admin delete answer', js: true do
      log_in(admin)
      visit question_path(question)

      within '.answers' do
        click_on 'Delete answer'
        expect(page).to_not have_content user_answer.body
      end
    end
  end
end
