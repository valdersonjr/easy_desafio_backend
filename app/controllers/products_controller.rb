class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @products = Product.paginate(page: page, per_page: per_page)

    if @products.any?
      render json: {
        products: ProductSerializer.new(@products).serializable_hash,
        meta: pagination_meta(@products)
      }, status: :ok
    else
      render json: { message: 'There is no existing product' }, status: :not_found
    end
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product
      render json: ProductSerializer.new(@product).serializable_hash
    else
      render json: { message: 'Product not found' }, status: :not_found
    end
  end

  def create
    if current_user.profile != 'admin'
      render json: { message: 'You are not allowed to create a product' }, status: :forbidden
      return
    end

    @product = Product.new
    @product.attributes = product_params
    save_product!
  end

  def update
    if current_user.profile != 'admin'
      render json: { message: 'You are not allowed to update a product' }, status: :forbidden
      return
    end

    @product = Product.find_by(id: params[:id])

    if @product
      @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash
    else
      render json: { message: 'Product not found' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: "An error occurred" }, status: :internal_server_error
  end

  def destroy
    if current_user.profile != 'admin'
      render json: { message: 'You are not allowed to create a product' }, status: :forbidden
      return
    end

    @product = Product.find_by(id: params[:id])

    if @product
      @product.destroy
      render json: { message: 'Product successfully deleted' }, status: :ok
    else
      render json: { message: 'Product not found' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: "An error occurred" }, status: :internal_server_error
  end

  private

  def product_params
    return {} unless params.has_key?(:product)
    params.require(:product).permit(:name, :ballast)
  end

  def save_product!
    @product.save!
    render json: ProductSerializer.new(@product).serializable_hash, status: :created
  rescue StandardError => e
    render json: { error: "An error occurred" }, status: :internal_server_error
  end
end
