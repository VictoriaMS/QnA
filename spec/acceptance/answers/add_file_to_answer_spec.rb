require 'acceptance/acceptance_helper'

feature 'Add file to answer', %q{
  In order to illustrate own answer 
  As an author of the answer 
  I want to able to attach file
} do 
  given(:user)      { create(:user) }
  given!(:question) { create(:question) }

  background do 
    log_in(user)
    visit question_path(question)
  end

  scenario 'User adds file the creating answer', js: true do 
    fill_in 'Body', with: 'New answer with file'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create Answer'

    within '.answers' do 
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end
