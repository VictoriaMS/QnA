require 'acceptance/acceptance_helper'

feature 'Add file to question', %q{
  In order to illustrate own question
  As an author of the question
  I wan to be able to attach file
} do 
  given(:user) { create(:user) }
  
  background do 
    log_in(user)
    visit new_question_path

  end

  scenario 'User adds file when creating question' do 
    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'New body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end
