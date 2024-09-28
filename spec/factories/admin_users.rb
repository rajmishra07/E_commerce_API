# spec/factories/admin_users.rb
FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }  # Generates a random email using Faker
    password { "password" }          # Default password
    password_confirmation { "password" }
  end
end
