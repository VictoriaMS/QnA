require 'acceptance/acceptance_helper'

feature 'add multiple files to question', %q{
  In order to illustrate own question
  As an author of the question
  I want to be able to attach some files
} do 
  given(:user) { create(:user) }

  background do 
    log_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'New body'

    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
  end

  scenario 'User adds some files when creating question', js: true do 
    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Create'

    expect(page).to have_content 'Title question'
    expect(page).to have_content 'New body'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
