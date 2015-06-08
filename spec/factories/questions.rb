FactoryGirl.define do
  factory :question do
    sequence (:title) { |n| "MyTitle#{n}" }
    body 'MyText'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
