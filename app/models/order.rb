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

  def deliver
    update(status: Status.delivered) 
  end

  def cancel
    update(status: Status.canceled)
  end

  def delivered
    update(status: Status.delivered) 
  end

  scope :canceled, -> { where('status_id = ?', Status.canceled.id ) }
  scope :delivered, -> { where('status_id = ?', Status.delivered.id ) }
  scope :active, -> { where('status_id = ?', Status.active.id ) }

  

  def total_cost_in_dollars
    cost = self.total_cost
    cents = (cost % 100).to_s
    if ( cents.to_s.length == 1 )
      cents = '0' + cents
    end
    dollars = (cost / 100).to_s
    return dollars + '.' + cents
  end
end