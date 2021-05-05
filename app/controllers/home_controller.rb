class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index, :how_it_works]
  def index
    @products = Product.all.limit(4)
    @latest_products = Product.all.limit(4).order(created_at: :desc)
  end

  def privacy_policy
  end
end
