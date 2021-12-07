# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  protect_from_forgery

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include Pagy::Backend

  before_action :set_global_variables
  def set_global_variables
    # navbar search
    @ransack_products = Product.ransack(params[:products_search], search_key: :products_search)
  end

  private

  # pundit
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  protected

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end
end
