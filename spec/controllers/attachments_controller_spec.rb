require 'rails_helper'
require "byebug"
RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer_with_file) { create(:answer, :with_file, question: question, author: author) }

  describe 'DELETE #destroy' do

    context 'Author' do
      before { login(author) }

      it 'deletes his answers attached file' do
        expect { delete :destroy, params: { id: answer_with_file.files[0] }, format: :js }.to change(answer_with_file.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer_with_file.files[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    it 'Not author tries to delete attached file' do
      login(user)

      expect { delete :destroy, params: { id: answer_with_file.files[0] }, format: :js }.to_not change(answer_with_file.files, :count)
    end

    it 'Guest tries to delete attached file' do
      expect { delete :destroy, params: { id: answer_with_file.files[0] }, format: :js }.to_not change(answer_with_file.files, :count)
    end
  end
end
