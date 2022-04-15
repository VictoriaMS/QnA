require 'acceptance/acceptance_helper'

feature 'vote for answer', %q{
  In order to highlight a useful or not useful answer
  As a authenticated user
  I want to be able to vote for answer
} do

  let(:user)     { create(:user) }
  let(:author)   { create(:user) }
  let(:question) { create(:question) }
  let!(:answer)  { create(:answer, question: question, user: author) } 

  describe 'Authenticated user' do 
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario 'votes up for answer', js: true do
      within '.answers' do
        click_on 'Vote up'
  
        within '.voted_up' do
          expect(page).to have_content '1'
        end
      end
    end
  
    scenario 'votes down for answer', js: true do
      within '.answers' do
        click_on 'Vote down'
  
        within '.voted_down' do 
          expect(page).to have_content '1'
        end
      end
    end
  end

  describe 'Author of the answer' do
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
