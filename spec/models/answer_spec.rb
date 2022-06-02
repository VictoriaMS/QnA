require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { create(:answer) }
  it_behaves_like 'Votable'
  it_behaves_like 'Attachable'

  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  let!(:user)     { create(:user) }
  let!(:question) { create(:question, user: user) }
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

  describe 'sending notification of the new answer to the author of the question' do 
    subject { build(:answer) }
    
    it 'send an email when creating an answer' do 
      expect(NotificationMailer).to receive(:new_answer).with(subject).and_call_original
      subject.save!
    end

    it 'does not send email when updating an answer' do 
      subject.save!
      expect(NotificationMailer).to_not receive(:new_answer).with(subject)
      subject.update(body: '123')
    end
  end
end
