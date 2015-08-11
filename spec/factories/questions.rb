FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "MyTitle#{n}" }
    body 'MyText'
    user

    trait :old do
      created_at { 1.day.ago }
    end

    factory :old_question, traits: [:old]
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
