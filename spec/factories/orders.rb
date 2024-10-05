FactoryBot.define do
  factory :order do
    user
    total_price { 9.99 }
    status { 'pending' }

    trait :with_order_items do
      after(:create) do |order|
        create_list(:order_item, 2, order: order)
      end
    end
  end
end
