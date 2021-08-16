require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Is the user an author' do
    let(:not_author) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, question: question, author: author) }

    it 'user is an author' do
      expect(author).to eq question.author
      expect(author).to eq answer.author
    end

    it 'user is not an author' do
      expect(not_author).to_not eq question.author
      expect(not_author).to_not eq answer.author
    end
  end
end
