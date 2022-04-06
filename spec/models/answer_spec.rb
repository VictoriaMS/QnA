require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :body }

  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question) }
  let!(:answers)  { create_list(:answer, 2, question: question) }

  
  it '#mark_best' do 
    answer.mark_best!

    expect(question.answers.best_answer.first).to eq answer
  end
end
