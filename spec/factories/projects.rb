FactoryBot.define do
  factory :project do
    name { Faker::App.name }
  end
end
