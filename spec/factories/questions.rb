FactoryBot.define do
  sequence :title do |n|
    "title question number #{n}"
  end

  sequence :body do |n|
    "Body question number #{n}"
  end

  factory :question do
    body 
    title
    user

    factory :invalid_question do 
      body  { nil } 
      title { nil } 
    end
  end
end
