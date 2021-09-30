require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions_yesterday) { create_list(:question, 2, :yesterdays, author: user) }
    let!(:questions_before_yesterday) { create_list(:question, 2, :before_yesterdays, author: user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders yesterday's questions" do
      questions_yesterday.each do |question|
        within "#{mail.body}" do
          expect(mail.body.encoded).to have_content question.title
        end
      end
    end

    it "not renders the day's before yesterday" do
      questions_before_yesterday.each do |question|
        within "#{mail.body}" do
          expect(mail.body.encoded).to_not have_content question.title
        end
      end
    end
  end
end
