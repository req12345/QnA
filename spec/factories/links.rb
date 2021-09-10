FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'http://valid.com' }

    association :linkable, factory: :question

    trait :invalid do
      url { 'invalid.com' }
    end

    trait :gist do
      url { 'http://gist.github.com' }
    end
  end
end
