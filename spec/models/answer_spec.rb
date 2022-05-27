require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { create(:answer) }
  it_behaves_like 'Votable'

  it { should belong_to(:question) }
  it { should have_many(:attachments) }
  
  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :body }

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
