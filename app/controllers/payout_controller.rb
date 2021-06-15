class PayoutController < ApplicationController
  def transfer
    if current_user.balance_cents > 0
      Stripe::Transfer.create({
        amount: (current_user.balance_cents * 100).to_i, #this amount needs to be in cents
        currency: "usd",
        destination: current_user.stripe_user_id,
      })
      current_user.balance_cents = 0
      current_user.save
    end
  end
end