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

  def thank_you
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    UserMailer.contact_form(@name, @email, @message).deliver_now
  end

  def no_route
    redirect_to static_pages_page_404_path    
  end
end
