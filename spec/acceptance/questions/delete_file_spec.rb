require 'acceptance/acceptance_helper'

feature 'deleting question file', %q{
  In order to ensure that all attached files are up to date
  As an author of the question
  I want to be able to delete attachments
} do 
  let(:another_user) {create(:user)}
  let(:user)         { create(:user) }
  let!(:question)    { create(:question, user: user) }
  let!(:attachment)  { create(:attachment, attachable: question) }

  scenario 'Author of the question deletes attached file', js: true do 
    log_in(user)
    visit question_path(question)
    within '.attachments' do
      click_on 'Delete file'

      expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
    end
  end
  
  scenario 'Authenticated user removes a file from a question that is not their own' do 
    log_in(another_user)
    visit question_path(question)
    
    within '.attachments' do
      expect(page).to_not have_link 'Delete file'
    end
  end
 
end
