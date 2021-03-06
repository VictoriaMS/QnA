require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { create(:answer) }
  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'

  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'best_answer' do   
    let!(:question) { create(:question) }
    let!(:answer)   { create(:answer, question: question) }
    let!(:answers)  { create_list(:answer, 2, question: question) }
    
    it '#mark_best' do 
      answer.mark_best!

      expect(question.answers.best_answer.first).to eq answer
    end

    it '#unmark_best' do 
      answer.mark_best!
      answer.unmark_best!
      
      expect(question.answers.best_answer.count).to eq 0
    end
  end

  describe 'sending notification of the new answer to the subscribers of the question' do 
    let!(:user)     { create(:user) }
    let!(:unsigned) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscribe) { QuestionSubscribe.create(question_id: question.id, user_id: user.id) } 
    subject { build(:answer, question: question) }

    
    it 'send an email when creating an answer' do 
      question.reload
      question.question_subscribes.each do |subscribe|
        expect(NotificationMailer).to receive(:for_subscribers).with(subscribe.user, subject).and_call_original
      end
      subject.save!
    end

    it 'does not send email when updating an answer' do 
      subject.save!
      expect(NotificationMailer).to_not receive(:for_subscribers).with(subscribe.user, subject).and_call_original
      subject.update(body: '123')
    end
  end
end
