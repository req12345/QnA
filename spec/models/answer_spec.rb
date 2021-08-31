require 'rails_helper'
require 'byebug'
RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe 'Answer of question' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answers) { create_list(:answer, 3, question: question, author: user) }

    it 'is not best answer' do
      question.best_answer = question.answers.first
      
      expect(question.answers.second).to be_not_best_of(question)
      expect(question.answers.third).to be_not_best_of(question)
    end
  end
end
