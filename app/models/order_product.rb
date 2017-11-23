# order_product model(exists to represent "order -> many_to_many <- product" )
class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
end
