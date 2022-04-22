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
      visit question_path(question)
    end  

    scenario 'votes up for question', js: true do
      click_on 'Vote up'
      
      within ".raiting_#{question.id}" do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes down for question', js: true do
      click_on 'Vote down'
  
      within ".raiting_#{question.id}" do 
       expect(page).to have_content '-1'
      end
    end
  end

  describe 'User who voted up', js: true do
    background do
      log_in(user)
      visit question_path(question)
      click_on 'Vote up'
      question.reload
    end

    scenario 'votes up for the second time' do 
      click_on 'Vote up'

      expect(page).to have_content 'You cannot vote for this question'
    end

    scenario 'votes down for the second time' do
      click_on 'Vote down'

      expect(page).to have_content 'You cannot vote for this question'
    end

    scenario 'revoke the vote' do
      click_on 'Revote'

      within ".raiting_#{question.id}" do 
        expect(page).to have_content '0'
      end
    end
  end

  describe 'User who voted down', js: true do
    before do
      log_in(user) 
      visit question_path(question)
      click_on 'Vote down'
      question.reload
    end

    scenario 'votes up for the second time' do 
      click_on 'Vote up'

      expect(page).to have_content 'You cannot vote for this question'
    end

    scenario 'votes down for the second time' do
      click_on 'Vote down'

      expect(page).to have_content 'You cannot vote for this question'
    end

    scenario 'revoke the vote' do 
      click_on 'Revote'

      within ".raiting_#{question.id}" do 
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author user' do
    before do 
      log_in(author) 
      visit question_path(question)
    end

    scenario 'votes up for question' do
      expect(page).to_not have_link 'Vote up'
    end

    scenario 'votes down for question' do
      expect(page).to_not have_link 'Vote down'
    end
  end
end
