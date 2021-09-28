require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me'}
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Response successful'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:response_resource) { json['user'] }
        let(:resource) { me }
      end

      it_behaves_like 'Private fields'
    end
  end

  describe 'GET /api/v1/profiles/all' do
    let(:api_path) { '/api/v1/profiles/all'}
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(method, api_path,
                          params: { access_token: access_token.token },
                          headers: headers) }

      it_behaves_like 'Response successful'

      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { json['users'] }
        let(:resource) { User.count - 1 }
      end

      it 'does not contains current_user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:response_resource) { json['users'].last }
        let(:resource) { user }
      end

      it_behaves_like 'Private fields'
    end
  end
end
