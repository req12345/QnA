FactoryBot.define do
  factory :reward do
    title { 'reward' }
    association :question, factory: :question
  end
end
