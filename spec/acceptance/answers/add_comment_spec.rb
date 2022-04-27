require 'acceptance/acceptance_helper'

feature 'add comment for answer', %q{
  In order to clarify information from the author of the answer
  As an authenticated user 
  I want to be able to post a comment  
} do
  let(:user)      { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question) }

  scenario 'Authenticeted user leaves a comment', js: true do 
    log_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Add a comment'
      fill_in 'New comment', with: 'New comment'
      click_on 'Comment'

      within ".comments-for-answer-#{answer.id}" do
        expect(page).to have_content 'New comment'
      end
    end
  end
end
