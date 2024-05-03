class SortedOrderProductsController < ApplicationController
  # before_action :authenticate_user!
  # before_action :require_admin, only: [:create, :update, :destroy]

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
      @q = SortedOrderProduct.ransack(params[:q])
      @sorted_order_products = @q.result
      @sorted_order_products = @sorted_order_products.order(params[:sort]) if params[:sort].present?
      @sorted_order_products = @sorted_order_products.paginate(page: page, per_page: per_page)

      if @sorted_order_products.any?
        pagination_meta(@sorted_order_products)
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
end
