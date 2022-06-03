require 'acceptance/acceptance_helper' 

feature 'unsubscribe from the question', %q{
  In order not to receive unnecessary letters
  As an user 
  I want to be able to unsubscribe from the question
} do   

  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  
  describe 'Authenticated user' do 
    before do 
      log_in(user)
      visit question_path(question)
    end

    context 'subscribed user' do 
      before { click_on 'subscribe to notifications of new answers' }

      scenario 'the user sees the unsubscribe link' do 
        expect(page).to have_link 'unsubscribe from the question'
      end

      scenario 'user unsubscribes from the question' do 
        click_on 'unsubscribe from the question'

        expect(page).to have_content 'You unsubscribed from the question'
      end
    end

    scenario 'unsubscribed user unsubscribes from the question' do
      expect(page).to_not have_link 'unsubscribe from the question'
    end
  end

  scenario 'Unauthenticated user unsubscribes from the question' do 
    visit question_path(question)
    expect(page).to_not have_link 'unsubscribe from the question'
  end
end
