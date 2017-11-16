class OrderProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :order_product
  load_and_authorize_resource :order_product, through: :order
  
  def create
    order = Order.find(params[:order_id])
    order_product = OrderProduct.new(order_product_params)
    order.order_products << order_product
    if order_product.save
      redirect_back fallback_location: root_url, notice: 'Product added to cart successfully'
    else
      redirect_back fallback_location: root_url, alert: 'Product was not added to cart' 
    end
  end

  def destroy
    order_product = OrderProduct.find(params[:id])
    order_product.destroy
    redirect_back fallback_location: root_url, notice: 'Product removed from cart successfully'
  end

  private
  def order_product_params
    params.require(:order_product).permit(:product_id)
  end
end