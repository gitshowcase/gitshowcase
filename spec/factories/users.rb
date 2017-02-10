FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    password 'password'
  end
end
