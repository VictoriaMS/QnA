require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "for subscribers" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.for_subscribers(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("For subscribers")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

    it 'contains the link to answer' do
      expect(mail.body.to_s).to match(answer.body)
    end
  end
end
