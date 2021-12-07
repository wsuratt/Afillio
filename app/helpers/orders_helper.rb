# frozen_string_literal: true

module OrdersHelper
  def stripe_button_link
    stripe_url = 'https://connect.stripe.com/express/oauth/authorize'
    redirect_uri = stripe_connect_url
    client_id = Rails.application.credentials.dig(Rails.env.to_sym, :stripe, :oauth)

    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end

  def total_earnings
    if current_user.has_role?(:admin)
      orders = Order.where(paid: true)
      stripe_fee_total = Order.stripe_fee * orders.length
      afillio_fee_total = ((orders.sum(:total) / 100.00) - stripe_fee_total) * Order.afillio_fee
      number_to_currency(afillio_fee_total + stripe_fee_total)
    elsif current_user.has_role?(:vendor)
      orders = Order.joins(:product).where(products: { user: current_user }, paid: true)
      number_to_currency((orders.sum(:vendor_commission) / 100.00))
    else
      orders = Order.where(orders: { user: current_user }, paid: true)
      number_to_currency((orders.sum(:seller_commission) / 100.00))
    end
  end
end
