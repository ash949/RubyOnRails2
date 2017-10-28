class Product < ApplicationRecord
  # has_many :orders
  has_many :order_product_records
  has_many :orders, through: :order_product_records
end
