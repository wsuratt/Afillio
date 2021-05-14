class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:new, :create, :show]
  before_action :set_order, only: %i[ show update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
    authorize @orders
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
  # def edit
  # end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    # @order.product = Product.friendly.find(params[:title])
    @order.total = @order.product.price * @order.quantity
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        @product = @order.product
        @user = @order.user
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
# redirect_to :action => "new", :title => @order.product.title, :referral_token => @order.user.referral_token
  # PATCH/PUT /orders/1 or /orders/1.json
  # def update
  #   respond_to do |format|
  #     if @order.update(order_params)
  #       format.html { redirect_to @order, notice: "Order was successfully updated." }
  #       format.json { render :show, status: :ok, location: @order }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    authorize @order
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
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
      params.require(:order).permit(:product_id, :user_id, :quantity, :total, :street_address, :city, :state, :zipcode, :first_name, :last_name, :phone, :email)
    end
    
end
