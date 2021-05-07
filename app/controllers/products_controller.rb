class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    #@products = Product.all
    @ransack_products = Product.ransack(params[:products_search], search_key: :products_search)
    @pagy, @products = pagy(@ransack_products.result.includes(:user))
  end

  def show
    @qrcode = RQRCode::QRCode.new(request.original_url)
    
    @svg = @qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
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
        format.html { redirect_to @product, notice: "Product was successfully created." }
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
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @product
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :category, :quantity, :price, :commission)
    end
end
