class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @products = Product.all.limit(3)
    @latest_products = Product.all.limit(3).order(created_at: :desc)
  end

  def privacy_policy
  end
end
