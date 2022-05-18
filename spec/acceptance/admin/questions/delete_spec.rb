require 'acceptance/acceptance_helper'

feature 'admin can delete any question', %q{
  In order to keep all questions in the system up to date
  As an admin 
  I want to be able to delete any question
} do 
  let(:admin) { create(:admin) }
  let(:user)  { create(:user) }
  let!(:admin_question) { create(:question, user: admin) }
  let!(:user_question)  { create(:question, user: user) }
 
  scenario 'admin delete own question' do 
    log_in(admin) 
    visit question_path(admin_question) 

    click_on 'Destroy'

    expect(page).to_not have_content admin_question.title
    expect(page).to_not have_content admin_question.body
  end

  scenario 'admin delete user question' do 
    log_in(admin) 
    visit question_path(user_question) 

    click_on 'Destroy'

    expect(page).to_not have_content user_question.title
    expect(page).to_not have_content user_question.body
  end
end
