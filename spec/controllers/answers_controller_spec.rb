require 'rails_helper'
require 'byebug'
RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:not_author) { create :user }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #mark_as_best' do
    context 'Author' do
      before { login(user) }

      it 'marks answer as best' do
        post :mark_as_best, params: { id: answer, format: :js }
        question.reload
        expect(question.best_answer_id).to eq answer.id
      end

      it 'renders template mark_as_best' do
        post :mark_as_best, params: { id: answer, format: :js }
        expect(response).to render_template :mark_as_best
      end
    end

    context 'Not author' do
      before { login(not_author) }

      it 'can not marks answer as best' do
        post :mark_as_best, params: { id: answer, format: :js }
        question.reload
        expect(question.best_answer).to eq nil
      end
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, author: user, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, user_id: user, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 're-renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not auhthor' do
      before { login(not_author) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end
    end

    context 'Guest' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #udpate' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answers attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'not changes answers attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end
  end

  context 'Not author' do
    it 'tries to update answer' do
      login(not_author)
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to_not eq 'new body'
    end
  end

  context 'Guest' do
    it 'tries to update answer' do
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to_not eq 'new body'
    end
  end
end
