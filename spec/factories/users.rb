FactoryBot.define do
  factory :user do
    email { 'sample@esm.co.jp' }
    password { 'password' }
    encrypted_password { Devise::Encryptor.digest(User, 'password') }
  end
end
