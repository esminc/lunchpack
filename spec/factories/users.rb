FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email(domain: 'esm.co.jp') }
    password { 'password' }
    encrypted_password { Devise::Encryptor.digest(User, 'password') }
  end
end
