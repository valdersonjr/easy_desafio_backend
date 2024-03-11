class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    begin
      @q = Order.ransack(params[:q])
      @orders = @q.result
      @orders = @orders.order(params[:sort]) if params[:sort].present?
      @orders = @orders.paginate(page: page, per_page: per_page)

      if @orders.any?
        pagination_meta(@orders)
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
end
