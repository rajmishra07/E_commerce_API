class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_id, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["cart", "product"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["cart_id", "created_at", "id", "product_id", "quantity", "updated_at"]
  end
end
