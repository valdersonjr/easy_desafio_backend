class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

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

  def show
    begin
      @order = Order.find_by(id: params[:id])
      if @order
        render 'show', status: :ok
      else
        @error_message = 'Order not found'
        render 'show_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'show_error', status: :not_found
    end
  end

  def create
    @order = Order.new
    @order.attributes = order_params

    if valid_load?(order_params[:load_id])
      @error_message = 'Load not found'
      render 'create_error', status: :not_found
      return
    end

    begin
      @order.save!
      render 'create', status: :created
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'create_error', status: :unprocessable_entity
    end
  end

  def update
    begin
      @order = Order.find_by(id: params[:id])
      if @order
        @order.attributes = order_params
        @order.save!
        render 'update', status: :ok
      else
        @error_message = 'Order not found'
        render 'update_error', status: :not_found
      end
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'update_error', status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @order = Order.find_by(id: params[:id])
      if @order
        @order.destroy
        render 'destroy', status: :ok
      else
        @error_message = 'Order not found'
        render 'destroy_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotDestroyed => error
      @error_message = error
      render 'destroy_error', status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:code, :bay, :load_id)
  end

  def valid_load?(load_id)
    Load.find_by(id: load_id).nil?
  end
end
