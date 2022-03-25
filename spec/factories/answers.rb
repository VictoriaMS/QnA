FactoryBot.define do
  factory :answer do
    body { 'foo' }

    question

    factory :invalid_answer  do 
      body { nil }
    end
  end
end
