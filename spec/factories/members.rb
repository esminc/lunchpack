FactoryBot.define do
  factory :member do
    handle_name { Faker::Internet.user_name }
    real_name { Faker::Name.name }
    email { Faker::Internet.unique.email(domain: 'esm.co.jp') }
  end
end
