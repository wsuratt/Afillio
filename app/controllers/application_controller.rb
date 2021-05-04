class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery
  
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  before_action :set_global_variables
  def set_global_variables
    @ransack_products = Product.ransack(params[:products_search], search_key: :products_search) #navbar search
  end
  
  private

  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
