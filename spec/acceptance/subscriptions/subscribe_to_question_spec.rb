require 'acceptance/acceptance_helper'

feature 'subscribe to question', %q{
  In order to follow the new answers to the question that interests me
  As an user
  I want to be able to subscribe to it and receive email notifications
} do 
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'Authenticated user' do 
    before do 
      log_in(user)
      visit question_path(question)
    end

    scenario 'subscribed user' do
      click_on 'subscribe to notifications of new answers'
      click_on 'subscribe to notifications of new answers'

      expect(page).to have_content 'You are already subscribed to this question'
    end

    scenario 'unsubscribed user' do 
      click_on 'subscribe to notifications of new answers'

      expect(page).to have_content 'You subscribed to notifications of new answers for this question'
    end
  end


  scenario 'Unauthenticated user try to subscribe' do 
    visit question_path(question)

    expect(page).to_not have_link 'subscribe to notifications of new answers'
  end
end
