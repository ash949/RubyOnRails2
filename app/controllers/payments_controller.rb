class PaymentsController < ApplicationController
  def create
    token = params[:stripeToken]
    
    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: current_user.active_order.total_cost, # amount in cents, again
        currency: "usd",
        source: token,
        description: params[:stripeEmail][0,22]
      )
      if charge.paid        
        redirect_to user_order_path(@product.id), notice: 'transaction has successfully been completed'
      end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to user_order_path(current_user.active_order.id)
    end
  end
end