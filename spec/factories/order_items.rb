FactoryBot.define do
  factory :order_item do
    order
    product { create(:product) }
    quantity { 1 }
    price { product.price * quantity }
  end
end
