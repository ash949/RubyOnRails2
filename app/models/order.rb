class Order < ApplicationRecord
  belongs_to :user
  has_many :order_product_records
  has_many :products, through: :order_product_records
end