require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:reward) { create(:reward, question: question, user: user) }
  let(:not_users_reward) { create(:reward, question: question) }

  describe 'GET #rewards' do
    context 'User' do
      before do
        login(user)
        get :rewards, params: {id: user}
      end

      it 'renders index view' do
        expect(response).to render_template :rewards
      end

      it 'has reward' do
        expect(assigns(:rewards)).to eq([reward])
      end

      it 'has not reward' do
        expect(assigns(:rewards)).to_not eq([not_users_reward])
      end
    end
  end
end
