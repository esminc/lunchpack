FactoryBot.define do
  factory :lunch do
    date { Faker::Date.between(from: Date.new(2019, 8, 1), to: Date.current) }
  end
end
