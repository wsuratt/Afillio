class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index, :how_it_works, :privacy_policy, :about_us, :become_vendor, :terms_conditions]
  def index
    @latest = Product.latest
    @popular = Product.popular
    @sold_products = Product.joins(:orders).where(orders: {user: current_user}).order(created_at: :desc).limit(4)
  end

  def privacy_policy
  end
end
