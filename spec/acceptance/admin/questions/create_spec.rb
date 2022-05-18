require 'acceptance/acceptance_helper'

feature 'admin creates question', %q{
  In order to find the answer to my question
  As an admin
  I want to be able to create question
} do 

  let(:admin) { create(:admin) }
  
  scenario 'Admin can to create question' do 
    log_in(admin)

    visit root_path 
    click_on 'Ask question' 

    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'Body question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_text 'Title question'
    expect(page).to have_text 'Body question'
  end
end
