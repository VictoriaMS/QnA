require 'acceptance/acceptance_helper'

feature 'deleting answer file', %q{
  In order to ensure that all attached files are up to date
  As an author of the answer
  I want to be able to delete attachments
} do
  let(:another_user) { create(:user) }
  let(:user)         { create(:user) }
  let!(:question)    { create(:question) }
  let!(:answer)      { create(:answer, user: user, question: question) }
  let!(:attachment)  { create(:attachment, attachable: answer) } 

  scenario 'Author of the answer deletes attached file', js: true do
    log_in(user)
    visit question_path(question)
    within '.answers' do
      within '.attachments' do
        click_on 'Delete file'

        expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
      end
    end
  end

  scenario 'Authenticated user removes a file from an answer that is not their own' do
    log_in(another_user)
    visit question_path(question)

    within '.answers' do
      within '.attachments' do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
