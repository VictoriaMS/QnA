require 'rails_helper'


RSpec.describe OmniauthCallbacksController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    before do
      request.env['omniauth.auth'] = facebook_mock_auth_hash
      get :facebook, params: { omniauth_auth: request.env['omniauth.auth'] }
    end
    
    it 'assigns the user' do 
      expect(assigns(:user)).to be_a(User)
    end

    it 'redirect to questions path' do 
      expect(response).to redirect_to root_path
    end 
  end

  describe 'GEt #twitter' do 
    context 'not verified email' do
      it 'renders the email template' do
        request.env['omniauth.auth'] = twitter_mock_auth_hash
        get :twitter, params: { omniauth_auth: request.env['omniauth.auth'] }
        expect(response).to render_template :email_request
      end
    end
  end

  describe 'POST #set_email' do
    context 'email is present' do
      it 'redirects to questions_path' do
        post :set_email, params: { email: 'test@qna.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'email is not present' do
      it 'renders email template' do
        post :set_email, params: { email: '' }
        expect(response).to render_template :email_request
      end
    end
  end
end
