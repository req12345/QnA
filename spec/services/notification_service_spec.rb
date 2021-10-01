require 'rails_helper'

RSpec.describe NotificationService do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  it 'sends notification' do
    NotificationService.new(answer).send_notification
  end
end
