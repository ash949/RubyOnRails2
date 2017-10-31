class StaticPagesController < ApplicationController
  def index
  end

  def landing_page
    @search_form = true
    @featured_products = Product.limit(3)
  end

  def contact
    @search_form = false
    @branches = Branch.all
  end

  def page_404
    @search_form = false
  end

  def thank_you
    @search_form = false
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    UserMailer.contact_form(@name, @email, @message).deliver_now
  end

  def no_route
    @search_form = false
    redirect_to static_pages_page_404_path    
  end
end
