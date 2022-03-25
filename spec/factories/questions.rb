FactoryBot.define do
  factory :question do
    body  { 'foo' }
    title { 'bar' }
  end

  factory :invalid_question, class: 'Question' do 
    body  { nil } 
    title { nil } 
  end
end
