require 'rails_helper'

feature 'create answer', %q{
  In order to share knowledge and help another user
  As an user 
  I want to be able to create an answer to a question
} do 
  given(:question) { create(:question) }

  scenario 'create answer' do 
    visit question_path(question)
    fill_in 'Body', with: 'answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'answer'
  end
end
