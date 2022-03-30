require 'rails_helper'

feature 'view all answers', %q{
  In order to know what answers already exist
  As an user 
  I want to be able to view all answers 
} do 
   
  given(:question)  { create(:question) }
  given!(:answers)  { create_list(:answer, 3, question: question) }
  
  scenario 'User views all answers' do 
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
