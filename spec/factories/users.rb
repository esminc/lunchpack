FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email(domain: 'esm.co.jp') }
    password { Faker::Internet.password }
  end
end
