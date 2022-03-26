require 'rails_helper'

feature 'view the question and his answers', %q{
  In order to find the answer to a question
  As an user 
  I want to able to view the question and all the answers to it
}do 
  given!(:question) { create(:question) }
  given(:answer) { create_list(:answer, 2, question) }

  scenario 'view the question and his answers' do
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body 

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
