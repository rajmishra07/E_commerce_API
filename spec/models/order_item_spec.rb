require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order) { create(:order) }
  let(:product) { create(:product) }
  let(:order_item) { build(:order_item, order: order, product: product) }
  
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0.01) }
  end

  describe 'callbacks' do
    it 'sets price before validation' do
      order_item.quantity = 2
      order_item.save
      expect(order_item.price).to eq(product.price * order_item.quantity)
    end
  end
end
