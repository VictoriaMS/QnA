FactoryBot.define do
  factory :answer do
    sequence(:body)  { |n| "Body answer number #{n}" }
    question
    user

    factory :invalid_answer  do 
      body { nil }
    end
  end
end
