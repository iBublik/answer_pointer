FactoryGirl.define do
  factory :answer do
    question
    user
    sequence(:body) { |n| "Answer example #{n}" }
    is_solution false

    trait :solution do
      is_solution true
    end

    factory :solution_answer, traits: [:solution]
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user nil
  end
end
