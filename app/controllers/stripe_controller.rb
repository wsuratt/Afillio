# frozen_string_literal: true

class StripeController < ApplicationController
  def connect
    response = HTTParty.post('https://connect.stripe.com/oauth/token',
                             query: {
                               client_secret: Rails.application.credentials.dig(Rails.env.to_sym,
                                                                                :stripe, :secret),
                               code: params[:code],
                               grant_type: 'authorization_code'
                             })

    if response.parsed_response.key?('error')
      redirect_to my_sales_orders_path,
                  notice: response.parsed_response['error_description']
    else
      stripe_user_id = response.parsed_response['stripe_user_id']
      current_user.update_attribute(:stripe_user_id, stripe_user_id)

      redirect_to my_sales_orders_path,
                  notice: 'User successfully connected with Stripe!'
    end
  end
end
