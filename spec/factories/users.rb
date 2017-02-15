FactoryGirl.define do
  factory :user do
    transient do
      with_mailchimp_callbacks false
    end

    sequence(:username) { |n| "username#{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    password 'password'

    after(:build) do |user, evaluated|
      unless evaluated.with_mailchimp_callbacks
        class << user
          def mailchimp_subscribe;
          end

          def mailchimp_subscribe_change;
          end

          def mailchimp_unsubscribe;
          end
        end
      end
    end
  end
end
