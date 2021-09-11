class PayoutController < ApplicationController
  before_action :set_amount
  
  def transfer
    if @amount > 0
      Stripe::Transfer.create({
        amount: (@amount * 100).to_i, #this amount needs to be in cents
        currency: "usd",
        destination: current_user.stripe_user_id,
      })
      current_user.balance_cents = 0
      current_user.save
    end
  end
  
  private
  
  def set_amount
    @amount = current_user.balance_cents
  end
end