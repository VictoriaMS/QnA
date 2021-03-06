FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password              { '123456' } 
    password_confirmation { '123456' } 
  end

  factory :admin, class: User do 
    email
    password              { '123456' } 
    password_confirmation { '123456' } 
    admin { true }
  end
end
