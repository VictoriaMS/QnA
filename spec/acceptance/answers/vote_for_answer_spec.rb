require 'acceptance/acceptance_helper'

feature 'vote for answer', %q{
  In order to highlight a useful or not useful answer
  As a authenticated user
  I want to be able to vote for answer
} do

  let(:user)      { create(:user) }
  let(:author)    { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question, user: author) } 

  describe 'Authenticated user'  do 
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario 'votes up for answer', js: true do
      within '.answers' do
        click_on 'Vote up'
  
        within ".raiting_#{answer.id}" do
          expect(page).to have_content '1'
        end     
      end
    end
  
    scenario 'votes down for answer', js: true do
      within '.answers' do
        click_on 'Vote down'
  
        within ".raiting_#{answer.id}" do 
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User who voted up', js: true do
    before do
      log_in(user)
      visit question_path(question)
      click_on 'Vote up'
      answer.reload
    end

    scenario 'votes up for the second time' do 
      click_on 'Vote up'

      expect(page).to have_content 'You cannot vote for this answer'
    end

    scenario 'votes down for the second time' do
      click_on 'Vote down'

      expect(page).to have_content 'You cannot vote for this answer'
    end

    scenario 'revoke the vote' do
      click_on 'Revote'

      within ".raiting_#{answer.id}" do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'User who voted down', js: true do
    before do
      log_in(user) 
      visit question_path(question)
      click_on 'Vote down'
      answer.reload
    end

    scenario 'votes up for the second time' do 
      click_on 'Vote up'

      expect(page).to have_content 'You cannot vote for this answer'
    end

    scenario 'votes down for the second time' do
      click_on 'Vote down'

      expect(page).to have_content 'You cannot vote for this answer'
    end

    scenario 'revoke the vote' do
      answer.reload
      click_on 'Revote'

      within ".raiting_#{answer.id}" do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author of the answer', js: true do
    before do 
      log_in(author)
      visit question_path(question)
    end

    scenario 'votes up for own answer' do
      within '.answers' do
        expect(page).to_not have_link 'Vote up'
      end
    end

    scenario 'votes down for own answer' do
      within '.answers' do
        expect(page).to_not have_link 'Vote down'
      end
    end
  end 
end
