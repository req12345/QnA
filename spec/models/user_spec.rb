require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'The user' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'is an author' do
      expect(author).to be_author_of(question)
    end

    it 'is not an author' do
      expect(user).to_not be_author_of(question)
    end
  end
end
