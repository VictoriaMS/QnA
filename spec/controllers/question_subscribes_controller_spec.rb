require 'rails_helper' 

RSpec.describe QuestionSubscribesController, type: :controller do 
  describe 'POST #create' do 
    let(:question) { create(:question) }
    log_in_user

    it 'assigns the requested question to @question'do 
      post :create, params: { question_id: question.id }
      expect(assigns(:question)).to eq question
    end

    it 'a subscription has been created' do
      expect { post :create, params: { question_id: question.id } }.to change(QuestionSubscribe, :count).by(1)
    end
  end
end
