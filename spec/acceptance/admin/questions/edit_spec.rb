require 'acceptance/acceptance_helper'

feature 'admin edit question', %q{
  In order to fix mistake 
  As an admin
  I want to able to edit any question
} do 

  let!(:admin) { create(:admin) }
  let!(:user)  { create(:user) }
  let!(:admin_question) { create(:question, user: admin) }
  let!(:user_question)  { create(:question, user: user) }

  before do 
    log_in(admin)
    visit question_path(admin_question)
  end

  scenario "Admin edit own question" do 
    click_on 'Edit'
    fill_in 'Title', with: 'edited title'
    fill_in 'Question', with: 'edited question'
    click_on 'Save'

    expect(page).to_not have_content admin_question.title
    expect(page).to_not have_content admin_question.body
    expect(page).to have_content 'edited title'
    expect(page).to have_content 'edited question'
  end

  scenario "Admin edit user question" do 
    click_on 'Edit'
    fill_in 'Title', with: 'edited title'
    fill_in 'Question', with: 'edited question'
    click_on 'Save'

    expect(page).to_not have_content user_question.title
    expect(page).to_not have_content user_question.body
    expect(page).to have_content 'edited title'
    expect(page).to have_content 'edited question'
  end
end
