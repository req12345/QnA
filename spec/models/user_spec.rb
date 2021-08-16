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

    it 'user is an author' do
      expect(true).to be author.author_of?(question)
    end

    it 'user is not an author' do
      expect(false).to be not_author.author_of?(question)
    end
  end
end
