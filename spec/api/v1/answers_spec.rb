require 'rails_helper'
require "byebug"
describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) {create(:question, author: user)}
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, author: user) }
      let(:params) { { question_id: question.id,access_token: access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it_behaves_like 'Response successful'

      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { json['answers'] }
        let(:resource) { answers.size }
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body user_id question_id created_at updated_at] }
        let(:response_resource) { json['answers'].first }
        let(:resource) { answers.first }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, :with_file, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    let(:access_token) { create(:access_token) }
    let(:params) { {question_id: question.id, access_token: access_token.token } }
    it_behaves_like 'API authorizable'

    before { do_request(method, api_path, params: params, headers: headers) }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it_behaves_like 'Response successful'

    it_behaves_like 'Public fields' do
      let(:attributes) { %w[id body created_at updated_at] }
      let(:response_resource) { answer_response }
      let(:resource) { answer }
    end

    context 'Files' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { answer_response['files'] }
        let(:resource) { answer.files.size }
      end
    end

    context 'Links' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { answer_response['links'] }
        let(:resource) { answer.links.size }
      end
    end

    context 'Comments' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { answer_response['comments'] }
        let(:resource) { answer.comments.size }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user)  { create(:user) }
    let(:question) { create(:question, author: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }


    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end
  #
    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        post api_path, params: { question: question,
                                 author: user,
                                 answer: attributes_for(:answer),
                                 access_token: access_token.token }
      end

      context 'with valid attributes' do
        it 'saves a new question in database' do
          expect(Answer.count).to eq 1
        end

        it 'returns successful status' do
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:params) { {question: question,
                        answer: attributes_for(:answer, :invalid),
                        access_token: access_token.token} }

        it 'does not saves question' do
          expect{ post api_path, params: params }.to_not change(Answer, :count)
        end

        before { post api_path, params: params }

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'contains list of errors' do
          expect(response.body).to match /errors/
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, body: "MyAnswer", question: question, author: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        before do
          patch api_path, params: { id: answer,
            question: question,
            answer: { body: 'new body' },
            access_token: access_token.token }
        end

        it_behaves_like 'Response successful'

        it "assigns the requested answer to @answer" do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'new body'
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { id: answer,
            question: question,
            answer: attributes_for(:answer, :invalid),
            access_token: access_token.token }
        end

        it "not changes question attirbutes" do
          answer.reload

          expect(answer.body).to eq 'MyAnswer'
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'contains list of errors' do
          expect(response.body).to match /errors/
        end
      end


      context 'not author tries to update question' do
        let(:user) { create(:user) }
        let(:other_access_token) { create(:access_token, resource_owner_id: user.id) }

        before do
          patch api_path, params: { id: answer,
            question: question,
            answer: attributes_for(:answer, :invalid),
            access_token: other_access_token.token }
        end

        it "not changes question attirbutes" do
          answer.reload

          expect(answer.body).to eq 'MyAnswer'
        end

        it 'returns 302 status' do
          expect(response.status).to eq 302
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      before do
        delete api_path, params: { id: answer, access_token: access_token.token}
      end

      it_behaves_like 'Response successful'

      it 'deletes the answer' do
        expect(Answer.count).to eq 0
      end

      it 'returns successful message' do
        expect(json['messages']).to include('Your answer deleted')
      end
    end

    context 'not authorized' do
      let(:user) { create(:user) }
      let(:other_access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) { { id: answer, question: question, access_token: other_access_token.token } }

      before do
        delete api_path, params: params, headers: headers
      end

      it 'tries to delete answer' do
        expect(Answer.count).to eq 1
      end

      it 'returns status 403' do
        expect(response.status).to eq 403
      end
    end
  end
end
