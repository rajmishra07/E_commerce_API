class Product < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :price, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "updated_at", "user_id"]
  end

   def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

end 
