class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  has_many :products, through: :order_products
  belongs_to :status

  validates :user, presence: true

  def total_cost
    sum = 0
    products.each do |product|
      sum += product.price_in_cents
    end
    return sum
  end
end