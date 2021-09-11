require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns the  new link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns the new Reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }

    context 'Author do' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'not changes question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          end.to_not change(question, :title)
        end
        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'Not author' do
      it 'tries to update question' do
        not_author = create(:user)
        login(not_author)

        patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to_not eq 'new body'
      end
    end

    context 'Guest' do
      it 'tries to update question' do
        patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }

    context 'Author' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not auhthor' do
      let(:not_author) { create :user }
      before { login(not_author) }

      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Guest' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
