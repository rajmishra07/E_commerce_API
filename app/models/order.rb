class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items

  STATUSES = %w[pending paid shipped completed canceled].freeze

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  # Calculate the total price from order items
  before_save :calculate_total_price

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status", "total_price", "updated_at", "user_id"]
  end

  private

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.price.to_f }
  end
end