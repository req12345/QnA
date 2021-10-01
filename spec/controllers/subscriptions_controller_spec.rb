require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:create_request) { post :create, params: { question_id: question, format: :js } }

    context 'authenticated user' do
      before { login(user) }

      it 'saves question subscription in database' do
        expect { create_request }.to change(question.subscriptions, :count).by(1)
      end

      it 'assigns subscription to current_user' do
        create_request
        expect(assigns(:subscription).user).to eq user
      end
    end

    context 'Guest' do
      it "does not save subscription in database " do
        expect { create_request }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, author: another_user) }
    let!(:subscription) { create(:subscription, question: another_question, user: another_user) }
    let(:destroy_request) { delete :destroy, params: { id: subscription, format: :js } }

    context 'authenticated user' do
      it "deletes subscription from database" do
        login(another_user)
        expect { destroy_request }.to change(another_question.subscriptions, :count).by(-1)
      end
    end

    context 'another authenticated user' do
      it "tries to delete another's user subscription" do
        login(user)
        expect { destroy_request }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'Guest' do
      it 'does not delete the subscription' do
        expect { destroy_request }.to_not change(another_question.subscriptions, :count)
      end
    end
  end
end
