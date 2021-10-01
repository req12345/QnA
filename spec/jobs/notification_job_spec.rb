require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double(NotificationService) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService #notification' do
    expect(service).to receive(:send_notification)
    NotificationJob.perform_now(answer)
    end
end
