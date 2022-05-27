require 'rails_helper'

describe 'Answers API' do 
  describe 'GET /index' do 
    it_behaves_like 'API Authenticable'

    context 'authorized' do 
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers)  { create_list(:answer, 3, question: question) }

      before { get "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns correct amount answers' do 
        expect(response.body).to have_json_size(answers.size).at_path("answers")
      end

      %w(id body created_at updated_at user_id question_id raiting best_answer).each do |attr|
        it "answer object contains #{ attr }" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("answers/0/#{ attr }")
        end
      end
    end

    def do_request(options = {})
      question = create(:question)
      get "/api/v1/questions/#{ question.id }/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do 
    it_behaves_like 'API Authenticable'

    context 'authorized' do 
      let(:access_token) { create(:access_token) }
      let!(:answer)      { create(:answer) }
      let!(:comments)    { create_list(:comment, 3, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }

      before { get "/api/v1/answers/#{ answer.id }", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at user_id question_id raiting best_answer).each do |attr|
        it "answer object contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{ attr }")
        end
      end

      context 'comments' do 
        it 'included correct amount comments' do 
          expect(response.body).to have_json_size(comments.size).at_path("answer/comments")
        end

        %w(id body created_at updated_at commentable_id commentable_type user_id).each do |attr| 
          it "comment object contains #{ attr }" do 
            expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json).at_path("answer/comments/0/#{ attr }")
          end
        end
      end

      context 'attachments' do 
        it 'included correct amount in answer object' do 
          expect(response.body).to have_json_size(attachments.size).at_path("answer/attachments")
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("answer/attachments/0/url")
        end

        %w(id file created_at updated_at attachment_id attachment_type).each do |attr|
          it "attachment object does not contains #{ attr }" do 
            expect(response.body).to_not have_json_path("answer/attachments/0/#{ attr }")
          end
        end
      end
    end    

    def do_request(options = {})
      answer = create(:answer)
      get "/api/v1/answers/#{ answer.id }", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do 
    let(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    describe 'authorized' do 
      let(:access_token) { create(:access_token) }
      let(:user)         { create(:user) }

      context 'with valid attributes' do 
        it 'returns 200 status' do 
          post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, 
                                       answer: attributes_for(:answer, question_id: question.id, user_id: user.id) }
          expect(response).to be_success
        end

        it 'changes the number of answer' do 
          expect{  post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, 
                  answer: attributes_for(:answer, question_id: question.id, user_id: user.id) } }.to change(question.answers, :count).by(1) 
        end

        %w(body raiting best_answer created_at updated_at).each do |attr|
          it "contains path for #{ attr }" do
            post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, 
                                         answer: attributes_for(:answer, question_id: question.id, user_id: user.id) }
            expect(response.body).to have_json_path("answer/#{attr}")
          end
        end
      end

      context 'with valid attributes' do 
        it 'returns 422 status' do 
           post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, answer: {body: nil} }
          expect(response.status).to eq 422
        end

        it 'doest not saves answer' do 
          expect{  post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, 
                                          answer: {body: nil} } }.to_not change(question.answers, :count)
        end

        it 'contains errors' do 
          post "/api/v1/questions/#{ question.id }/answers", params: { format: :json, access_token: access_token.token, answer: {body: nil} }
          expect(response.body).to have_json_path('errors')
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{ question.id }/answers", params: { format: :json }.merge(options)
    end
  end
end
