require 'acceptance/acceptance_helper'

feature 'add multiple files to answer', %q{
  In order to illustrate own answer
  As an author of the answer
  I want to be able to attach some files
} do 
  given(:user)      { create(:user) }
  given!(:question) { create(:question) }

  background do 
    log_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'New answer'

    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
  end

  scenario 'User adds some files when creating question', js: true do 
    click_on 'add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Create'

    expect(page).to have_content 'New answer'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
