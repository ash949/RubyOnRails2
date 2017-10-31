class Product < ApplicationRecord
  has_many :order_product_records
  has_many :orders, through: :order_product_records
  
  def self.search(search_term)
    search_term.strip!
    if (Rails.env.development? || Rails.env.test?)
      Product.where('lower(name) LIKE ?', "%#{search_term}%")
    else
      Product.where('lower(name) ilike ?', "%#{search_term}%")
    end
    
  end
end
