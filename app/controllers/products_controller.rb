# products controller
class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  load_and_authorize_resource except: %i[index show]
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @search_term = params[:search_term]
    @featured_products = @products.featured
    @products = @products.search(params[:search_term]) if params[:search_term]
    @products = @products.paginate(page: params[:page], per_page: 9)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @comment = Comment.new
    @comments = @product.comments.id_desc
    @comments = @comments.paginate(page: params[:page], per_page: 5)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        notice_message = 'Product was successfully created.'
        format.html { redirect_to @product, notice: notice_message }
        format.json { render :show, status: :created, location: @product }
      else
        handle_product_errors(flash, format, @product, :new)
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to @product, notice: 'Product was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @product }
      else
        handle_product_errors(flash, format, @product, :edit)
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html do
        redirect_to products_url, notice: 'Product was successfully removed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::ActiveRecordError
    redirect_to root_url, alert: 'No valid ID provided to show the object'
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def product_params
    params.require(:product).permit(
      :name, :image_url, :description,
      :features, :price_in_cents, :showcase_images
    )
  end

  def handle_product_errors(flash, format, product, template)
    flash[:error] = product.errors.full_messages
    flash[:model] = 'product'
    format.html { render template }
    format.json do
      render json: product.errors, status: :unprocessable_entity
    end
  end
end
