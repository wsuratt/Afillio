class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:create, :success]
  
  def create
    order = Order.friendly.find(params[:id])
    product = order.product
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        name: product.title,
        amount: order.total_cents,
        currency: "usd",
        quantity: 1
      }],
      mode: 'payment',
      success_url: root_url + 'checkout/success' + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url + 'orders/' + order.slug,
      client_reference_id: order.id,
    })
    respond_to do |format|
      format.js
    end
  end
  
  def success
    if params[:session_id].present? 
      @session = Stripe::Checkout::Session.retrieve({ id: params[:session_id] })
      @order = Order.find_by(id: @session.client_reference_id)
    else
      redirect_to root_url, alert: "No info to display"
    end
  end

  def cancel
  end

end 