FactoryBot.define do
  factory :quarter do
    period { 40 }
    ordinal { 1 }
    start_date { Date.new(2019, 8, 1) }
    end_date { Date.new(2019, 10, 31) }
  end
end
