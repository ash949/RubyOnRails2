class Product < ApplicationRecord
  has_many :order_products
  has_many :orders, through: :order_products

  has_many :comments

  validates :name, presence: true
  validates :price_in_cents, numericality: {greater_than_or_equal_to: 0}
  validates :price_in_cents, numericality: {integer_only: true}
  
  def self.search(search_term)
    search_term.strip!
    if (Rails.env.development? || Rails.env.test?)
      Product.where('lower(name) LIKE ?', "%#{search_term}%")
    else
      Product.where('lower(name) ilike ?', "%#{search_term}%")
    end
  end

  def highest_rating_comment
    comments.rating_desc.first
  end

  def lowest_rating_comment
    comments.rating_asc.first
  end

  def compute_average
    self.comments.average(:rating)
  end

  def price
    cents = (self.price_in_cents % 100).to_s
    if ( cents.to_s.length == 1 )
      cents = '0' + cents
    end
    dollars = (self.price_in_cents / 100).to_s
    return dollars + '.' + cents
  end
  
end
