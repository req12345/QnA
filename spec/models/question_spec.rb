require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }

  it { should have_db_index(:user_id) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
