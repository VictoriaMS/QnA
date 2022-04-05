require 'acceptance/acceptance_helper'

feature 'edit answer', %q{
  In order to fix mistake
  As an author of answer
  I want to able to edit my answer
} do 
  given(:user)         { create(:user) }
  given(:another_user) { create(:user)}
  given!(:question)    { create(:question) }
  given!(:answer)      { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user to edit answer' do 
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Authenticated user to edit non-own answer' do
    log_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenicated user' do 
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do 
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
