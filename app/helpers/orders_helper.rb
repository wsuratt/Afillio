module OrdersHelper
  def stripe_button_link
    stripe_url = "https://connect.stripe.com/express/oauth/authorize"
    redirect_uri = stripe_connect_url
    client_id = Rails.application.credentials[Rails.env.to_sym][:stripe][:oauth]
  
    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end
  
  def total_earnings(orders)
    number_to_currency((orders.sum(:seller_commission)/100)*0.03)
  end
end
