FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "http://valid.com" }

    trait :invalid do
      name { "MyString" }
      url { 'invalid.com' }
    end
  end
end
