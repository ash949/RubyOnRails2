class StaticPagesController < ApplicationController
  def index
  end

  def landing_page
    @featured_products = Product.limit(3)
  end

  def contact
    @branches = Branch.all
  end
end
