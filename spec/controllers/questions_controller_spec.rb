require 'rails_helper'

describe QuestionsController do
  let(:question) {create(Question)}

  describe 'GET #new' do
    before {get :new}

    it 'assigns a new question to @question' do 
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do 
    context 'with valid attributes' do 
      it 'saves the new question in the database' do 
        expect{ post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show'do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the question' do 
        expect{ post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new views' do 
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end
end
