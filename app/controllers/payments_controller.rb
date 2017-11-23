# payments controller - handles stripe actions
class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Create the charge on Stripe's servers - this will charge the user's card
    deliver_charge_paid_email_redirect if fill_charge.paid
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to user_order_path(current_user.active_order.id)
  end

  private

  def fill_charge
    Stripe::Charge.create(
      amount: current_user.active_order.total_cost, # amount in cents, again
      currency: 'usd',
      source: params[:stripeToken],
      receipt_email: params[:stripeEmail],
      description: 'OrderID: ' + current_user.active_order.id.to_s
    )
  end

  def deliver_charge_paid_email_redirect
    current_user.active_order.deliver
    current_user.active_order
    redirect_to user_orders_path(current_user.id),
                notice: 'transaction has successfully been completed'
  end
end
