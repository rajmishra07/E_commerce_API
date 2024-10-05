class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  before_validation :set_price
   def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "order_id", "price", "product_id", "quantity", "updated_at"]
  end

  private

  def set_price
    if product && quantity
      self.price = product.price * quantity
    else
      errors.add(:base, 'Invalid product or quantity')
    end
  end
end