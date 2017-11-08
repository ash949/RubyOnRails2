class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    token = params[:stripeToken]
    
    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        amount: current_user.active_order.total_cost, # amount in cents, again
        currency: "usd",
        source: token,
        description: params[:stripeEmail][0,22]
      )
      if charge.paid
        current_user.active_order.deliver
        current_user.active_order        
        redirect_to user_orders_path(current_user.id), notice: 'transaction has successfully been completed'
      end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to user_order_path(current_user.active_order.id)
    end
  end
end