FactoryBot.define do
  factory :comment do 
    sequence(:body)  { |n| "Body answer number #{n}" }
    user
  end
end
