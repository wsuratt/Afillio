class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials[:stripe][:webhook]
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end

    # Handle the event
    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      @order = Order.find_by(id: session.client_reference_id)
      @order.update(paid: true)
      # # seller
      # @order.user.balance += @order.seller_commission_cents
      # # vendor
      # @order.product.user.balance += @order.vendor_commission_cents
      # # admin
    end

    render json: { message: 'success' }
  end
end