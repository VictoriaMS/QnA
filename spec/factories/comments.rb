FactoryBot.define do
  factory :comment do 
    sequence(:body)  { |n| "Body comment number #{n}" }
    user
    commentable { |c| c.association(:question) }
  end
end
