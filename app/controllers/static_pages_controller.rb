class StaticPagesController < ApplicationController
  def index
  end

  def landing_page
    @featured_products = Product.limit(3)
  end

  def contact
    @branches = Branch.all
  end

  def page_404
  end

  def no_route
    redirect_to static_pages_page_404_path    
  end
end
