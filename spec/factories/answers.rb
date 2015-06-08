FactoryGirl.define do
  factory :answer do
    question
    user
    sequence(:body) { |n| "Answer example #{n}" }
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user nil
  end
end
