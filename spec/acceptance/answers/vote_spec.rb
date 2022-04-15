require 'acceptance/acceptance_helper'

feature 'vote for answer', %q{
  In order to highlight a useful or not useful answer
  As a authenticated user
  I want to be able to vote for answer
} do

  let(:user)     { create(:user) }
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) } 

  background do
    log_in(user)
    visit question_path(question) 
  end

  scenario 'Authenticated user votes up for answer', js: true do
    within '.answers' do
      click_on 'Vote up'

      within '.voted_up' do
        expect(page).to have_content '1'
      end
    end
  end
end
