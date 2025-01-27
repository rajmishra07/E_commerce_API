require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:order) { build(:order, user: user) }
  
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should accept_nested_attributes_for(:order_items) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(Order::STATUSES) }
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'callbacks' do
    it 'calculates total price before save' do
      order_item = build(:order_item, order: order, product: product, quantity: 2)
      order.order_items << order_item
      order.save
      expect(order.total_price).to eq(product.price * 2)
    end
  end
end
