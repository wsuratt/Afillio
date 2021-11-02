class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index, :welcome, :privacy_policy, :about_us, :become_vendor, :terms_conditions]
  def index
    @latest = Product.active.latest
    @popular = Product.active.popular
    @recent_sales = Product.active.joins(:orders).where(orders: {user: current_user, paid: true}).order_sales.limit(4)
  end

  def privacy_policy
  end
  
end
