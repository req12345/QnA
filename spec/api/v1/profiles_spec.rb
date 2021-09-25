require 'rails_helper'
require "byebug"
describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234'}, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      #let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end
    end
  end
end
