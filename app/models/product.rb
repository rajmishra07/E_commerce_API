class Product < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :price, :description, presence: true
end 
