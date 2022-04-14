require 'acceptance/acceptance_helper'

feature 'vote for question', %q{
  In order to highlight a useful or not useful question
  As a authenticated user
  I want to be able to vote for question
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  scenario 'Authenticated user votes up for question', js: true do
    log_in(user)
    visit questions_path

    click_on 'Vote up'
    
    within '.voted_up' do
      expect(page).to have_content '1'
    end
  end

  scenario 'Authenticated user votes down for question', js: true do
    log_in(user)
    visit questions_path

    click_on 'Vote down'

    within '.voted_down' do 
     expect(page).to have_content '1'
    end
  end
end
