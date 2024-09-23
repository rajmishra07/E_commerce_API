FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 0..100.0) }  
    description { Faker::Lorem.sentence }
    association :user  
  end
end