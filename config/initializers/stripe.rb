Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe][:secret]
