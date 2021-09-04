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

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |answer|
        answer.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end
  end
end
