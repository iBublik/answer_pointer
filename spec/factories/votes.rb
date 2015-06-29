FactoryGirl.define do
  factory :vote do
    user

    trait :value_up do
      value 1
    end

    trait :value_down do
      value -1
    end

    trait :invalid_value do
      value 100
    end

    factory :vote_up, traits: [:value_up]
    factory :vote_down, traits: [:value_down]
    factory :invalid_vote, traits: [:invalid_value]
  end

end
