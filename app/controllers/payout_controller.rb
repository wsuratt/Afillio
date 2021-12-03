# frozen_string_literal: true

class PayoutController < ApplicationController
  before_action :set_amount

  def transfer
    return unless @amount.positive?

    Stripe::Transfer.create({
                              amount: (@amount * 100).to_i, # this amount needs to be in cents
                              currency: 'usd',
                              destination: current_user.stripe_user_id
                            })
    current_user.balance_cents = 0
    current_user.save
  end

  private

  def set_amount
    @amount = current_user.balance_cents
  end
end
