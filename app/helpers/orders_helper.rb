module OrdersHelper
  def stripe_button_link
    stripe_url = "https://connect.stripe.com/express/oauth/authorize"
    redirect_uri = stripe_connect_url
    client_id = "ca_JewnrxC0ozaE2rNwNyJ7ot22tC7wYIXa"
  
    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end
  def transfer_button_link
    Stripe::Transfer.create({
      amount: current_user.balance,
      currency: "usd",
      destination: current_user.stripe_user_id,
    })
    current_user.balance = 0
  end
end
