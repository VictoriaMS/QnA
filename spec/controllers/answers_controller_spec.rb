require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe 'POST #create' do  
    log_in_user
    
    context 'with valid attributes' do 
      let(:valid_answer_attributes) { post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js} }
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

  describe 'PATCH #update' do
    log_in_user
    let(:answer) { create(:answer, body: 'answer body', question: question, user: @user ) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do 
        patch :update, params: { id: answer, answer: { body: 'edited body' }, question_id: question, format: :js }
        answer.reload
        expect(answer.body).to eq 'edited body'
      end
      it 'render to update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :update
      end
    end
  
    context 'with invalid attributes' do 
      it 'does not change answer in database' do 
        patch :update, params: { id: answer, answer: { body: nil }, question_id: question, format: :js }
        answer.reload
        expect(answer.body).to eq 'answer body'
      end
    end
  end

  describe 'PATCH #update_best_answer' do 
    log_in_user
    let(:answer) { create(:answer, question: question ) }

    it 'answer status update, for best answer' do 
      patch :update_best_answer, params: { id: answer, question_id: question, answer: { best_answer: true } }
      answer.reload
      expect(answer.best_answer).to eq true
    end
  end

  describe 'DELETE #destroy' do 
    before { question }
    log_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'deletes the answer' do 
      expect { delete :destroy, params: { id: answer, question_id: question, format: :js } }.to change(question.answers, :count).by(-1)
    end

    it 'render to destroy template' do
      delete :destroy, params: { id: answer, question_id: question, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
