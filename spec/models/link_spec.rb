require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'Validates url with' do
    let(:question) { create(:question) }
    let(:valid_link) { create(:link, linkable: question) }
    let(:invalid_link) { build(:link, :invalid, linkable: question) }

    it 'valid data' do
      expect(valid_link).to be_valid
    end

    it 'invalid data' do
      expect(invalid_link).to_not be_valid
    end
  end
end
