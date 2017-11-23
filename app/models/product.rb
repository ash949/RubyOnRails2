# product model
class Product < ApplicationRecord
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :comments

  validates :name, presence: true
  validates :price_in_cents, numericality: {
    greater_than_or_equal_to: 0, integer_only: true
  }

  scope :featured, -> { order(id: :desc).limit(3) }
  scope :search, lambda { |search_term|
    search_term.strip!
    if Rails.env.production?
      where('lower(name) ilike ?', "%#{search_term}%")
    else
      where('lower(name) LIKE ?', "%#{search_term}%")
    end
  }

  #============ product computed properties ================
  def highest_rating_comment
    comments.rating_desc.first
  end

  def lowest_rating_comment
    comments.rating_asc.first
  end

  def compute_average
    comments.average(:rating)
  end

  def price
    cents = (price_in_cents % 100).to_s
    cents = '0' + cents if cents.to_s.length == 1
    (price_in_cents / 100).to_s + '.' + cents
  end

  #============ Redis caching related methods ================
  def views
    $redis.get("product-#{id}")
  end

  def viewed
    $redis.incr("product-#{id}")
  end
end
