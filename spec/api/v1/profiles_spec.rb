require 'rails_helper'

describe 'Profile API' do 
  describe 'GET /me' do 
    it_behaves_like 'API Authenticable'

    context 'authorized' do 
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "contains #{attr}" do 
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do 
    it_behaves_like 'API Authenticable'

    context 'authorized' do 
      let!(:users) { create_list(:user, 3) }
      let(:authorized_user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: authorized_user.id) }

      before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } } 

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'returns correct amount of users' do 
        expect(response.body).to have_json_size(users.size)
      end

      it 'contains users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not contain authorization user' do 
        expect(response.body).to_not include_json(authorized_user.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{ attr } for each user" do 
          users.each_index do |i|
            expect(response.body).to have_json_path("#{i}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{ attr } for each user" do 
          users.each_index do |i|
            expect(response.body).to_not have_json_path("#{i}/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end 
end
