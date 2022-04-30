require 'acceptance/acceptance_helper'

feature 'choose best question answer', %q{
  In order to make it easier for other users to find answers
  As an author question
  I want to be able to choose the best answer
} do 
  let(:another_user) { create(:user) }
  let(:user)         { create(:user) }
  let!(:question)    { create(:question, user: user) }
  let!(:answers)     { create_list(:answer, 3, question: question)}

  scenario 'Unauthenticated user selects the best answer to a question' do 
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
  
  scenario 'Authenticated user selects the best answer to non-own question' do 
    log_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Author of question' do
    before do 
      log_in(user)
      visit question_path(question)
    end
    scenario 'sees link best answer' do 
      within '.answers' do
        expect(page).to have_link 'Best answer'
      end
    end

    scenario 'selects the best answer' do 
      within '.answers' do
        find("a#best_answer_#{answers.first.id}").click
        within '.best_answer' do
          expect(page).to have_content answers.first.body
        end
      end
    end

    scenario 'selects new best answer' do 
      within '.answers' do
        find("a#best_answer_#{answers.first.id}").click
        find("a#best_answer_#{answers.last.id}").click
      end

      within '.best_answer' do
        expect(page).to have_content answers.last.body
      end
    end
  end
end
