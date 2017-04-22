FactoryGirl.define do
  factory :invitation do
    inviter
    sequence(:invitee) { |n| "username#{n}" }
  end
end
