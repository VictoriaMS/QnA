require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:question_subscribes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user)              { create(:user) }
  let(:question)          { create(:question, user: user) }
  let(:not_user_question) { create(:question) }

  context '#author_of?' do 
    it 'returns true' do 
      expect(user).to be_author_of(question)
    end

    it 'returns false' do 
      expect(user).to_not be_author_of(not_user_question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let!(:session) { Hash[provider:'facebook',  uid: '123456'] }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(session)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        let!(:session) { Hash[provider: auth.provider,  uid: auth.uid, email: auth.info[:email]] }

        it 'does not create new user' do 
          expect{ User.find_for_oauth(session) }.to_not change(User, :count)
        end

        it 'crates authorization for user' do
          expect{ User.find_for_oauth(session) }.to change(user.authorizations, :count).by(1)
        end
        
        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(session).authorizations.first

          expect(authorization.provider).to eq session[:provider]
          expect(authorization.uid).to eq session[:uid]
        end

        it 'returns the user' do
          expect(User.find_for_oauth(session)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        let!(:session) { Hash[provider: auth.provider,  uid: auth.uid, email: auth.info[:email]] }

        it 'creates new user' do 
          expect{ User.find_for_oauth(session) }.to change(User, :count).by(1)
        end

        it 'returns new user' do 
         expect(User.find_for_oauth(session)).to be_a(User)
        end

        it 'fills user email' do 
          user = User.find_for_oauth(session)
          expect(user.email).to eq session[:email]
        end

        it 'creates authorization for user' do 
          user = User.find_for_oauth(session)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(session).authorizations.first
          expect(authorization.provider).to eq session[:provider]
          expect(authorization.uid).to eq session[:uid]
        end 
      end
    end
  end

  describe '.find_by_auth' do 
    let!(:user) { create(:user) }
    let!(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_by_auth(auth.provider, auth.uid)).to eq user
      end
    end

    context 'user has not authoriation' do 
      it 'dont return the user' do 
        expect(User.find_by_auth(auth.provider, auth.uid)).to eq nil
      end
    end
  end
end
