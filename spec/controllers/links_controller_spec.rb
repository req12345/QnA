require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question_with_link) { create(:question, :with_link, author: author) }

  describe 'DELETE #destroy' do

    context 'Author' do
      before { login(author) }

      it 'deletes his question link in his own' do
        expect { delete :destroy, params: { id: question_with_link.links[0] }, format: :js }.to change(question_with_link.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question_with_link.links[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    it 'Not author tries to delete link is not his own' do
      login(user)

      expect { delete :destroy, params: { id: question_with_link.links[0] }, format: :js }.to_not change(question_with_link.links, :count)
    end

    it 'Guest tries to delete link is not his own' do
      expect { delete :destroy, params: { id: question_with_link.links[0] }, format: :js }.to_not change(question_with_link.links, :count)
    end
  end
end
