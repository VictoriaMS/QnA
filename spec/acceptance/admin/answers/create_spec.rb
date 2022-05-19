require 'acceptance/acceptance_helper'

feature 'admin create answer', %q{
  In order to share knowledge and help another user
  As an admin
  I want to be able to create an answer to a question
} do 
  let!(:question) { create(:question) }
  let(:admin)    { create(:admin) }

  scenario 'admin create answer', js: true do 
    log_in(admin)
    visit question_path(question)
    fill_in 'Body', with: 'answer'
    click_on 'Create Answer'
    
    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'answer'
    end
  end
end
