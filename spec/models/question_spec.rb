require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should belong_to(:author) }

  it { should have_db_index(:user_id) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Answer of question' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:reward) { create(:reward, question: question, user: author) }

    it 'set best answer and get the reward to user' do
      expect(question.best_answer).to eq nil
      expect(reward.user).to_not eq user

      question.set_best_answer(answer)
      expect(question.best_answer).to eq answer
      expect(reward.user).to eq user
    end
  end
end
