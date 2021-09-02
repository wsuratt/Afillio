class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :show]
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @ransack_path = orders_path
    
    if current_user.has_role?(:admin)
      @q = Order.ransack(params[:q])
    else
      @q = Order.where(paid: true).ransack(params[:q])
    end
    @pagy, @orders = pagy(@q.result.includes(:user))
    authorize @orders
  end
  
  def my_sales
    @ransack_path = my_orders_orders_path
    @q = Order.where(orders: {user: current_user}, paid: true).ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:user))
  end
  
  def my_orders
    @ransack_path = my_orders_orders_path
    @q = Order.joins(:product).where(products: {user: current_user}, paid: true).ransack(params[:q])
    @pagy, @orders = pagy(@q.result.includes(:user))
    render 'index'
  end
  
  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @product = Product.friendly.find(params[:title])
    @user = User.friendly.find_by(referral_token: params[:referral_token])
    
    @order.product = @product
    @order.user = @user
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    if @order.product.quantity > 0
      # @order.product = Product.friendly.find(params[:title])
      @order.total_cents = @order.product.price_cents * @order.quantity
      @order.seller_commission_cents = @order.product.commission_cents * @order.quantity
      @order.admin_commission_cents = 0.075 * @order.product.price_cents * @order.quantity
      @order.vendor_commission_cents = (@order.product.price_cents * @order.quantity) - (@order.seller_commission_cents + @order.admin_commission_cents)
      
      respond_to do |format|
        if @order.save
          OrderMailer.with(order: @order).new_order_email.deliver_now
          format.html { redirect_to @order}
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
        flash.now[:error] = "Product is out of stock."
        format.html { render :new }
        format.json { head :no_content }
      end
    end
  end
  
  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    if @order.update(order_params)
      @order.total_cents = @order.product.price_cents * @order.quantity
      @order.seller_commission_cents = @order.product.commission_cents * @order.quantity
      @order.admin_commission_cents = 0.075 * @order.product.price_cents * @order.quantity
      @order.vendor_commission_cents = (@order.product.price_cents * @order.quantity) - (@order.seller_commission_cents + @order.admin_commission_cents)
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
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:product_id, :user_id, :quantity, :total, :total_cents, :street_address, :city, :state, :zipcode, :first_name, :last_name, :phone, :email, :seller_commission, :seller_commission_cents, :vendor_commission, :vendor_commission_cents, :admin_commission, :admin_commission_cents)
    end
    
end
