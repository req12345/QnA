FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |question|
        question.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end

    trait :with_link do
      after :create do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_reward do
      after :create do |question|
        create(:reward, question: question)
      end
    end

    trait :yesterdays do
      created_at { Date.yesterday }
    end

    trait :before_yesterdays do
      created_at { Date.yesterday - 1 }
    end
  end
end
