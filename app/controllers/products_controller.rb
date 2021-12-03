# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(show index)
  before_action :set_product, :set_user, only: %i(show edit update destroy)

  def index
    # @products = Product.all
    @ransack_path = products_path
    @ransack_products = if current_user&.has_role?(:admin)
                          Product.ransack(params[:products_search], search_key: :products_search)
                        else
                          Product.active.ransack(params[:products_search],
                                                 search_key: :products_search)
                        end
    @pagy, @products = pagy(@ransack_products.result.includes(:user))
  end

  def purchased
    @ransack_path = purchased_products_path
    @ransack_products = Product.joins(:orders).where(
      orders: { user: current_user }
    ).ransack(params[:products_search], search_key: :products_search)
    @pagy, @products = pagy(@ransack_products.result.includes(:user))
    render 'index'
  end

  def created
    @ransack_path = created_products_path
    @ransack_products = Product.where(user: current_user).ransack(params[:products_search],
                                                                  search_key: :products_search)
    @pagy, @products = pagy(@ransack_products.result.includes(:user))
    render 'index'
  end

  def show
    return unless current_user

    @qrcode = RQRCode::QRCode.new(
      "#{request.base_url}/orders/new/#{@product.slug}/#{@user.referral_token}"
    )

    @svg = @qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4
    )
  end

  def new
    @product = Product.new
    authorize @product
  end

  def edit
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    @product.user = current_user

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @product
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @product
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to @product, alert: 'Product has orders. Can not be deleted.'
    end
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def product_params
    params.require(:product).permit(
      :title,
      :description,
      :category,
      :quantity,
      :price,
      :price_cents,
      :commission,
      :commission_cents,
      :image,
      :show
    )
  end
end
