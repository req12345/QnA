require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #search' do
    before { get :search, params: { body: 'test body', type: 'All' } }

    it 'returns status 200' do
      expect(response.status).to eq 200
    end

    it 'renders search view' do
      expect(response).to render_template :search
    end
  end
end
