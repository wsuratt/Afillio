# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!,
                     only: %i(index welcome privacy_policy about_us become_vendor terms_conditions)
  def index
    @latest = Product.active.latest
    @popular = Product.active.popular
    @recent_sales = Product.active.joins(:orders).where(
      orders: { user: current_user, paid: true }
    ).order('orders.created_at DESC').limit(4)
  end

  def privacy_policy; end
end
