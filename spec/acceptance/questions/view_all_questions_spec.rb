require 'acceptance/acceptance_helper'

feature 'view all questions', %q{
  In order to know what questions already exist
  As an user 
  I want to be able to view all questions
} do
  given(:user)       { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'User views all questions' do 
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
  