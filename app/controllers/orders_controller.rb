# frozen_string_literal: true

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(new create edit update show)
  before_action :set_order,
                only: %i(show edit update destroy tracking_number tracking_number_update)

  # GET /orders or /orders.json
  def index
    @ransack_path = orders_path

    @q = Order.ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:user))
    authorize @orders
  end

  def my_sales
    @ransack_path = my_orders_orders_path
    @q = Order.where(orders: { user: current_user }, paid: true).ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:user))
  end

  def my_orders
    @ransack_path = my_orders_orders_path
    @q = Order.joins(:product).where(products: { user: current_user },
                                     paid: true).ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:user))
    render 'index'
  end

  def tracking_number; end

  def tracking_number_update
    authorize @order
    if @order.update(order_params) && !@order.tracking_number.blank?
      OrderMailer.with(order: @order).shipped_order_email.deliver_later
    end
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to my_orders_orders_path }
        format.json { render :index, status: :ok, location: @order }
      else
        format.html { render :tracking_number, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /orders/1 or /orders/1.json
  def show; end

  # GET /orders/new
  def new
    @order = Order.new
    @product = Product.friendly.find(params[:title])
    @user = User.friendly.find_by(referral_token: params[:referral_token])

    @order.product = @product
    @order.user = @user
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    if @order.product.quantity >= @order.quantity
      # @order.product = Product.friendly.find(params[:title])
      @order.total_cents = (@order.product.price_cents * @order.quantity) + Order.stripe_fee_cents
      @order.seller_commission_cents = @order.product.commission_cents * @order.quantity
      @order.admin_commission_cents =
        (Order.afillio_fee * @order.product.price_cents * @order.quantity) + Order.stripe_fee_cents
      @order.vendor_commission_cents =
        @order.total_cents - (@order.seller_commission_cents + @order.admin_commission_cents)

      respond_to do |format|
        if @order.save
          format.html { redirect_to @order }
          format.json { render :show, status: :created, location: @order }
        else
          @product = @order.product
          @user = @order.user
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        @product = @order.product
        @user = @order.user
        if @product.quantity.zero?
          flash.now[:error] = 'This item is out of stock. Sorry for the inconvenience.'
        else
          flash.now[:error] =
            "There is only #{@product.quantity} of this item in stock. Please adjust your order " \
            'accordingly.'
        end
        format.html { render :new }
        format.json { head :no_content }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    if @order.update(order_params)
      @order.total_cents = (@order.product.price_cents * @order.quantity) + Order.stripe_fee_cents
      @order.seller_commission_cents = @order.product.commission_cents * @order.quantity
      @order.admin_commission_cents =
        (Order.afillio_fee * @order.product.price_cents * @order.quantity) + Order.stripe_fee_cents
      @order.vendor_commission_cents =
        @order.total_cents - (@order.seller_commission_cents + @order.admin_commission_cents)
    end
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    authorize @order
    @order.destroy
    if current_user.has_role?(:admin)
      respond_to do |format|
        format.html { redirect_to orders_url, notice: 'Order was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to my_orders_orders_path, notice: 'Order was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:product_id,
                                  :user_id,
                                  :quantity,
                                  :total,
                                  :total_cents,
                                  :street_address,
                                  :street_address2,
                                  :city,
                                  :state,
                                  :zipcode,
                                  :first_name,
                                  :last_name,
                                  :phone,
                                  :email,
                                  :seller_commission,
                                  :seller_commission_cents,
                                  :vendor_commission,
                                  :vendor_commission_cents,
                                  :admin_commission,
                                  :admin_commission_cents,
                                  :tracking_number)
  end
end
