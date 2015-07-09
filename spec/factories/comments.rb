FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment example #{n}" }
    user

    trait :empty_comment do
      body nil
    end

    factory :invalid_comment, traits: [:empty_comment]
  end
end
