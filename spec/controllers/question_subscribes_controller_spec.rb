require 'rails_helper' 

RSpec.describe QuestionSubscribesController, type: :controller do 
  describe 'POST #create' do 
    let!(:question) { create(:question) }
    log_in_user

    it 'assigns the requested question to @question'do 
      post :create, params: { question_id: question.id }
      expect(assigns(:question)).to eq question
    end

    it 'a subscription has been created' do
      expect { post :create, params: { question_id: question.id } }.to change(question.question_subscribes, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do 
    log_in_user
    let(:question) { create(:question) }
    let!(:subscribe) { QuestionSubscribe.create(question_id: question.id, user_id: @user.id) }

    it 'assigns the subscribe to @subscribe' do 
      delete :destroy, params: { id: subscribe.id }
      expect(assigns(:subscribe)).to eq subscribe
    end

    it 'a subscription has been deleted' do 
      expect { delete :destroy, params: { id: subscribe.id } }.to change(question.question_subscribes, :count).by(-1)
    end
  end
end
