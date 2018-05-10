require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "notification" do
    let(:mail) { NotificationMailer.notification(question, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notification")
      expect(mail.to).to eq ([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
    end
  end
end