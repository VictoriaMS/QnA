require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe 'POST #create' do  
    log_in_user
    
    context 'with valid attributes' do 
      let(:valid_answer_attributes) { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js} }

      it 'saves the new answer in the database' do 
        expect{ valid_answer_attributes }.to change(question.answers, :count).by(1)
      end

      it 'assigns the requested question to @question' do
        valid_answer_attributes
        expect(assigns(:question)).to eq question
      end

      it 'saves the answer for current user' do
        expect { valid_answer_attributes }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the answer' do 
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(question.answers, :count)
      end

      it 're-renders new views' do 
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
