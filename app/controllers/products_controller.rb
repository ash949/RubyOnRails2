class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  # GET /products
  # GET /products.json
  def index
    @search_form = true
    if ( params[:search_term] )
      @products = Product.search(params[:search_term])
    else
      @products = Product.all
    end
    
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product.comments.each do |comment|
      
    end
    @search_form = true
  end

  # GET /products/new
  def new
    @search_form = false
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @search_form = false
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if( params[:order_id] )
      Order.find(params[:order_id]).products.delete(@product)
    else
      @product.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :image_url, :description, :features, :price, :showcase_images)
    end
end
