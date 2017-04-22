FactoryGirl.define do
  factory :plan do
    sequence(:name) { |n| "Plan #{n}" }
    sequence(:slug) { |n| "slug #{n}" }
    domain true
  end
end
