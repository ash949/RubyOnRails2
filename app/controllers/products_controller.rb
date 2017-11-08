class ProductsController < ApplicationController
  before_action :set_product, only: [:add_to_cart, :show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]  
  load_and_authorize_resource except: [:index, :show]
  # GET /products
  # GET /products.json
  def index
    @search_form = true
    if ( params[:search_term] )
      @products = Product.search(params[:search_term])
    else
      @products = Product.all
    end
    @products = @products.paginate(page: params[:page], per_page: 2)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @comment = Comment.new
    @comments = @product.comments.order(created_at: :desc).paginate(page: params[:page], per_page: 2)
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
        flash[:error] = @product.errors.full_messages
        flash[:model] = 'product'
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_to_cart
    if( current_user.id.to_i == params[:user_id].to_i )
      current_user.active_order.products << @product
      redirect_back fallback_location: root_url, notice: 'Product added to cart successfully'
    else
      redirect_to product_path(@product.id), alert: 'Your account is to be reviewed for suspenion'
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
        flash[:error] = @product.errors.full_messages
        flash[:model] = 'product'
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if( params[:order_id] )
      current_user.active_order.order_products.where('product_id = ?', @product.id).take.destroy
      redirect_to user_order_path(current_user.id, current_user.active_order.id)
    else
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully removed.' }
        format.json { head :no_content }
      end
    end
    
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      begin
        @product = Product.find(params[:id])  
      rescue Exception
        redirect_to root_url, alert: 'No valid ID provided to show the object'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :image_url, :description, :features, :price_in_cents, :showcase_images)
    end
end
