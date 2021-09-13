FactoryBot.define do
  factory :reward do
    name { 'reward' }
    association :question, factory: :question
  end
end
