class Product < ApplicationRecord
  has_many :order_products
  has_many :orders, through: :order_products

  has_many :comments

  validates :name, presence: true
  validates :price_in_cents, numericality: {
    greater_than_or_equal_to: 0, integer_only: true
  }

  
  def self.search(search_term)
    search_term.strip!
    if (Rails.env.production?)
      Product.where('lower(name) ilike ?', "%#{search_term}%")
    else
      Product.where('lower(name) LIKE ?', "%#{search_term}%")
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
    logger.debug "Converting product.price_in_cents from cents into dollars format"
    cents = (self.price_in_cents % 100).to_s
    logger.debug "Cents: #{cents}"
    if ( cents.to_s.length == 1 )
      cents = '0' + cents
      logger.debug "Cents: #{cents} (supposed to be two digits)"
    end
    dollars = (self.price_in_cents / 100).to_s
    logger.debug "Dollars except the remaining cents : #{dollars}"
    logger.debug "To be returned: #{dollars}.#{cents}"
    return dollars + '.' + cents
  end
  
end
