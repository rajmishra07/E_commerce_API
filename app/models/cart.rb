class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "user"]
  end

  def display_name
    "Cart ##{id} for #{user.email}"
  end
  
end
