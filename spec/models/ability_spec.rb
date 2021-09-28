require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :all, User, user: user }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create(:answer, question: other_question, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'comment' do
      it { should be_able_to :create_comment, Question }
      it { should be_able_to :create_comment, Answer }
    end

    context 'destroy' do
      it { should be_able_to :destroy, Question }
      it { should be_able_to :destroy, Answer }

      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end

    context 'vote' do
      it { should_not be_able_to [:vote_for, :vote_against, :cancel_voting], question }
      it { should be_able_to [:vote_for, :vote_against, :cancel_voting], other_question }
      it { should_not be_able_to [:vote_for, :vote_against, :cancel_voting], answer }
      it { should be_able_to [:vote_for, :vote_against, :cancel_voting], other_answer }
    end

    context 'mark as best' do
      it { should be_able_to :mark_as_best, answer }
      it { should_not be_able_to :mark_as_best, create(:answer, question: other_question, author: other) }
    end

    it { should be_able_to :destroy, ActiveStorage::Attachment }
    it { should be_able_to :me, User, user: user }
  end
end
