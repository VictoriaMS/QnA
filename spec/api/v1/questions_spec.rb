require 'rails_helper'

describe 'Questions API' do 
  describe 'GET /index' do 
    context 'unauthorized' do 
      it 'returns 401 status if there is no acess_token' do 
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do 
        get '/api/v1/questions', params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do 
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 3) }
      let!(:question)    { questions.first }

      before { get '/api/v1/questions', params: {format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of question' do 
        expect(response.body).to have_json_size(questions.size).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{ attr }" do 
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end 
    end
  end
end
