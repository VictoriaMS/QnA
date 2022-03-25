FactoryBot.define do
  factory :question do
    body  { 'foo' }
    title { 'bar' }

    factory :invalid_question do 
      body  { nil } 
      title { nil } 
    end
  end
end
