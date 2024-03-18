class OrderProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    if params[:q] && params[:q][:order_id_eq].present?
      params[:q][:order_id_eq] = params[:q][:order_id_eq].to_i
    end

    if params[:q] && params[:q][:product_id_eq].present?
      params[:q][:product_id_eq] = params[:q][:product_id_eq].to_i
    end

    begin
      @q = OrderProduct.ransack(params[:q])
      @order_products = @q.result
      @order_products = @order_products.order(params[:sort]) if params[:sort].present?
      @order_products = @order_products.paginate(page: page, per_page: per_page)

      if @order_products.any?
        pagination_meta(@order_products)
        render 'index', status: :ok
      else
        @error_message = 'There is no data to display.'
        render 'index_error', status: :no_content
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'index_error', status: :not_found
    end
  end

  def show; end

  def create
    @order_product = OrderProduct.new
    @order_product.attributes = order_product_params

    begin
      @order_product.save!
      render 'create', status: :created
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'create_error', status: :unprocessable_entity
    end
  end

  def update
    @order_product = OrderProduct.find(params[:id])

    begin
      @order_product.update!(order_product_params)
      render 'update', status: :ok
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'update_error', status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @order_product = OrderProduct.find(params[:id])
      @order_product.destroy!
      render 'destroy', status: :ok
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'destroy_error', status: :not_found
    end
  end

  private

  def order_product_params
    params.require(:order_product).permit(:order_id, :product_id, :quantity, :box)
  end
end
