class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :order, through: :user

  # GET /orders
  # GET /orders.json
  def index
    if ( current_user.admin? )
      @orders = Order.all
    else
      @orders = Order.all.where('user_id = ?', @user.id)
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to user_orders_url(@user.id), notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      begin
        @order = Order.find(params[:id])
      rescue Exception
        redirect_to root_url, alert: 'No valid ID provided to show the object'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id)
    end
end
