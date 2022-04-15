require 'acceptance/acceptance_helper'

feature 'vote for question', %q{
  In order to highlight a useful or not useful question
  As a authenticated user
  I want to be able to vote for question
} do
  let(:user)      { create(:user) }
  let(:author)    { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before do
      log_in(user)
      visit questions_path
    end  

    scenario 'votes up for question', js: true do
      click_on 'Vote up'
      
      within '.voted_up' do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes down for question', js: true do
      click_on 'Vote down'
  
      within '.voted_down' do 
       expect(page).to have_content '1'
      end
    end
  end

  describe 'Author of the question' do 
    before do 
      log_in(author)
      visit questions_path
    end

    scenario 'cannot vote up for his own question' do
      expect(page).to_not have_link 'Vote up'
    end

    scenario 'canntot vote down for his own question' do
      expect(page).to_not have_link 'Vote down'
    end
  end
end