FactoryBot.define do
  factory :cart_item do
    quantity { 1 }
    association :cart
    association :product
  end
end
