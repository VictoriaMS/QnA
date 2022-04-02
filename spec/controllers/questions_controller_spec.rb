require 'rails_helper'

describe QuestionsController do
  let(:question) { create(:question) }

  describe 'GET #new' do
    log_in_user
    before {get :new}

    it 'assigns a new question to @question' do 
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do 
    log_in_user

    context 'with valid attributes' do 
      it 'saves the new question in the database' do 
        expect{ post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
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

  describe 'PUTCH #update' do
    let(:question) { create(:question, title: 'title question', body: 'body question') }

    context 'valid_attributes' do 
      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do 
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render to update temlate' do 
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do 
      before { patch :update, params: {id: question, question: { title: 'new title', body: nil }, format: :js } }

      it 'does not change question attributes' do 
        question.reload
        expect(question.title).to eq 'title question'
        expect(question.body).to eq 'body question'
      end
    end
  end

  describe 'GET #index' do 
    before {get :index}
    let(:questions) { create_list(:question, 2) }

    it 'populates an array of all questions' do 
      expect(assigns(:questions)).to match_array(questions)  
    end

    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end 
end
