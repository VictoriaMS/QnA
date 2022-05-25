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

  describe 'GET /show' do 
    context 'unauthorized' do 
      let(:question) { create(:question) }

      it 'returns 401 status if there is no acess_token' do 
        get "/api/v1/questions/#{ question.id }", params: { format: :json }
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do 
        get "/api/v1/questions/#{ question.id }", params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do 
      let(:question)     { create(:question) }
      let(:access_token) { create(:access_token) }
      let!(:comments)    { create_list(:comment, 3, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } } 

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{ attr }" do 
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end 

      context 'comments' do 
        it 'included in question object' do 
          expect(response.body).to have_json_size(comments.size).at_path("question/comments")
        end 
        
        %w(id body created_at updated_at commentable_id commentable_type user_id).each do |attr|
          it "comment object contains #{ attr }" do 
            expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json).at_path("question/comments/0/#{ attr }")
          end
        end
      end

      context 'attachments' do 
        it 'included in question object' do 
          expect(response.body).to have_json_size(attachments.size).at_path("question/attachments")
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("question/attachments/0/url")
        end

        %w(id file created_at updated_at attachment_id attachment_type).each do |attr|
          it "attachment object does not contains #{ attr }" do 
            expect(response.body).to_not have_json_path("question/attachments/0/#{ attr }")
          end
        end
      end
    end
  end

  describe 'GET /create' do 
    describe 'unauthorized' do 
      it 'returns 401 status if there is no acess_token' do 

        post '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do 
        post '/api/v1/questions', params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    describe 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }

      context 'with valid attributes' do 
        it 'returns 200 status' do
          post'/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:question, user_id: user.id  ) } 
          expect(response).to be_success
        end

        it 'changes amount question' do 
          expect{ post'/api/v1/questions', params: { format: :json, access_token: access_token.token, 
                  question: attributes_for(:question, user_id: user.id) } }.to change(Question, :count).by(1)
        end 

        %w(title body created_at updated_at raiting).each do |attr|
          it "contains path for #{ attr }" do 
            post'/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:question, user_id: user.id) } 
            expect(response.body).to have_json_path("question/#{ attr }")
          end
        end
      end

      context 'with invalid attributes' do 
        it 'returns 422 status' do
          post'/api/v1/questions', params: { format: :json, access_token: access_token.token, question: {title: nil, body: nil} } 
          expect(response.status).to eq 422
        end

        it 'does not save question' do 
          expect{ post'/api/v1/questions', params: { format: :json, access_token: access_token.token, 
                  question: { title: nil, body: nil } } }.to_not change(Question, :count)
        end

        it 'returns errors' do 
          post'/api/v1/questions', params: { format: :json, access_token: access_token.token, question: {title: nil, body: nil} } 
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end
