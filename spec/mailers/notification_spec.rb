require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }
  let(:mail) { NotificationMailer.notification(user, answer) }

  it 'renders headers' do
    expect(mail.subject).to eq ("Notification")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["from@example.com"])
  end

  it "renders answer body" do
    expect(mail.body.encoded).to match(answer.body)
  end
end
