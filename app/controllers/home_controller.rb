class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @products = Product.all
  end

  def privacy_policy
  end
end
