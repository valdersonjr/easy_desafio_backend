class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

   begin
    @q = Product.ransack(params[:q])
    @products = @q.result
    @products = @products.order(params[:sort]) if params[:sort].present?
    @products = @products.paginate(page: page, per_page: per_page)

    if @products.any?
      pagination_meta(@products)
      render 'index', status: :ok
    else
      @error_message = 'There is no data to display.'
      render 'index_error', status: :not_found
    end
   rescue ActiveRecord::RecordNotFound => error
    @error_message = error
    render 'index_error', status: :not_found
   end
  end

  def show
    begin
      @product = Product.find_by(id: params[:id])
      if @product
        render 'show', status: :ok
      else
        @error_message = 'Product not found'
        render 'show_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'show_error', status: :not_found
    end
  end

  def create
    @product = Product.new
    @product.attributes = product_params

    begin
      @product.save!
      render 'create', status: :created
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'create_error', status: :unprocessable_entity
    end
  end

  def update
    begin
      @product = Product.find_by(id: params[:id])

      if @product
        @product.update!(product_params)
        render 'update', status: :ok
      else
        @error_message = 'Product not found'
        render 'update_error', status: :not_found
      end
      rescue ActiveRecord::RecordNotFound => error
        @error_message = error
        render 'update_error', status: :not_found
    end
  end

  def destroy
    begin
      @product = Product.find_by(id: params[:id])
      if @product
        @product.destroy
        render 'destroy', status: :ok
      else
        @error_message = 'Product not found'
        render 'destroy_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'destroy_error', status: :not_found
    end
  end

  private

  def product_params
    return {} unless params.has_key?(:product)
    params.require(:product).permit(:name, :ballast)
  end
end
