# orders controller
class OrdersController < ApplicationController
  before_action :set_order, except: [:index]
  before_action :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :order, through: :user

  # GET /orders
  # GET /orders.json
  def index
    @orders = if current_user.admin?
                Order.all
              else
                Order.all.where('user_id = ?', @user.id)
              end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show; end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      notice_message = 'Order was successfully destroyed.'
      u_id = @user.id
      format.html { redirect_to user_orders_url(u_id), notice: notice_message }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::ActiveRecordError
    redirect_to root_url, alert: 'No valid ID provided to show the object'
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def order_params
    params.require(:order).permit(:user_id)
  end
end
