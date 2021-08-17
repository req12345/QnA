FactoryBot.define do
  sequence :answer_body do |n|
    "Answer#{n}"
  end

  factory :answer do
    body { generate(:answer_body) }
    association :author, factory: :user
    question

    trait :invalid do
      body { nil }
    end
  end
end
