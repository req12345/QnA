require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe  'Vote' do
    let(:subject) { create(model.to_s.underscore.to_sym, author: author) }

    it '_for' do
      expect { subject.vote_for(user) }.to change { Vote.count }.from(0).to(1)
    end

    it '_against' do
      expect { subject.vote_against(user) }.to change { Vote.count }.from(0).to(1)
    end

    it "_cancel" do
      subject.vote_for(user)
      expect { subject.cancel_voting(user) }.to change { Vote.count }.from(1).to(0)
    end
  end
end
