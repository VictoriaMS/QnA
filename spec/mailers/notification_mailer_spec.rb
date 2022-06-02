require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "new_answer" do
    let(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.new_answer(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([answer.question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

    it 'contains the link to answer' do
      expect(mail.html_part.body.to_s).to match(answer.body)
    end
  end
end
