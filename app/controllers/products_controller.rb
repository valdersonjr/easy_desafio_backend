class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @q = Product.ransack(params[:q])
    @products = @q.result.paginate(page: page, per_page: per_page)

    if @products.any?
      render_json_response(nil, :ok, @products, pagination_meta(@products))
    else
      render_json_response('There is no existing product', :not_found, nil, nil)
    end
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product
      render_json_response(nil, :ok, @product, nil)
    else
      render_json_response('Product not found', :not_found, nil, nil)
    end
  end

  def create
    @product = Product.new
    @product.attributes = product_params
    save_product!
  end

  def update
    @product = Product.find_by(id: params[:id])

    if @product
      @product.update(product_params)
      render_json_response(nil, :ok, @product, nil)
    else
      render_json_response('Product not found', :not_found, nil, nil)
    end
  rescue StandardError => e
    render_json_response(e, :not_found, nil, nil)
  end

  def destroy
    @product = Product.find_by(id: params[:id])

    if @product
      @product.destroy
      render_json_response('Product successfully deleted', :ok, nil, nil)
    else
      render_json_response('Product not found', :not_found, nil, nil)
    end
  rescue StandardError => e
    render_json_response(e, :not_found, nil, nil)
  end

  private

  def product_params
    return {} unless params.has_key?(:product)
    params.require(:product).permit(:name, :ballast)
  end

  def save_product!
    @product.save!
    render_json_response(nil, :created, @product, nil)
  rescue StandardError => e
    render_json_response(e, :unprocessable_entity, nil, nil)
  end
end
