require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'Validates url' do
    let(:question) { create(:question) }
    let(:link) { create(:link, linkable: question) }

    context 'with' do
      let(:invalid_link) { build(:link, :invalid, linkable: question) }

      it 'valid data' do
        expect(link).to be_valid
      end

      it 'invalid data' do
        expect(invalid_link).to_not be_valid
      end
    end

    context 'is' do
      let(:gist_link) { create(:link, :gist, linkable: question) }

      it 'a gist' do
        expect(gist_link.gist?).to be_truthy
      end

      it "not a gist" do
        expect(link.gist?).to be_falsey
      end
    end
  end
end
