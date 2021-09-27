require 'rails_helper'
require "byebug"
describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it_behaves_like 'Response successful'

      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { json['questions'] }
        let(:resource) { questions.size }
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:response_resource) { question_response }
        let(:resource) { question }
      end

      it "contains user object" do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it "contains short title" do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'List of items returnable' do
          let(:responce_resource) { question_response['answers'] }
          let(:resource) { question.answers.size }
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body user_id created_at updated_at] }
          let(:response_resource) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end


  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_file, author: user) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:question_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it_behaves_like 'Response successful'

    it_behaves_like 'Public fields' do
      let(:attributes) { %w[id title body created_at updated_at] }
      let(:response_resource) { question_response }
      let(:resource) { question }
    end

    context 'Answers' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { question_response['answers'] }
        let(:resource) { question.answers.size }
      end
    end

    context 'Files' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { question_response['files'] }
        let(:resource) { question.files.size }
      end
    end

    context 'Links' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { question_response['links'] }
        let(:resource) { question.links.size }
      end
    end

    context 'Comments' do
      it_behaves_like 'List of items returnable' do
        let(:responce_resource) { question_response['comments'] }
        let(:resource) { question.comments.size }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'saves a new question in database' do
          expect { post api_path, params: { question: attributes_for(:question),
                   access_token: access_token.token } }.to change(Question, :count).by(1)
        end

        it 'returns successful status' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it 'does not saves question' do
          expect{ post api_path, params: { question: attributes_for(:question, :invalid),
            access_token: access_token.token } }.to_not change(Question, :count)
        end

        before { post api_path, params: { question: attributes_for(:question, :invalid),
                                          access_token: access_token.token } }

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'contains list of errors' do
          expect(response.body).to match /errors/
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions' do

    let!(:question) { create(:question)}
  end
end
