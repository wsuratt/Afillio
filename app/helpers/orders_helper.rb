module OrdersHelper
  def stripe_button_link
    stripe_url = "https://connect.stripe.com/express/oauth/authorize"
    redirect_uri = stripe_connect_url
    client_id = Rails.application.credentials[Rails.env.to_sym][:stripe][:oauth]
  
    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end
  
  def total_earnings
    if current_user.has_role?(:admin)
      orders = Order.all
      number_to_currency((orders.sum(:total)/100.00)*Order.AFILLIO_FEE)
    elsif current_user.has_role?(:vendor)
      orders = Order.joins(:product).where(products: {user: current_user}, paid: true)
      number_to_currency((orders.sum(:vendor_commission)/100.00))
    else
      orders = Order.where(orders: {user: current_user}, paid: true)
      number_to_currency((orders.sum(:seller_commission)/100.00))
    end
  end
end
