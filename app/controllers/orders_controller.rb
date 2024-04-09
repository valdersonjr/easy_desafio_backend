class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    begin
      @q = Order.ransack(params[:q])
      @orders = @q.result

      if params[:q] && params[:q][:has_product_eq] == 'true'
        order_ids = OrderProduct.distinct.pluck(:order_id)
        @orders = @orders.where(id: order_ids)
      end

      @orders = @orders.order(params[:sort]) if params[:sort].present?
      @orders = @orders.paginate(page: page, per_page: per_page)

      if @orders.any?
        pagination_meta(@orders)
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

  def show_order_by_load_code
    begin
      @load_id = find_load_by_code(params[:load_code])
      if(@load_id.nil?)
        @error_message = 'Load not found'
        render 'show_error', status: :not_found
        return
      end

      @order = Order.find_by(load_id: @load_id)
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
    @load_id = find_load_by_code(params[:order][:load_code])

    @order = Order.new

    @order.code = order_params[:code]
    @order.bay = order_params[:bay]
    @order.load_id = @load_id

    if(@load_id.nil?)
      @error_message = 'Load not found'
      render 'create_error', status: :unprocessable_entity
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

  def find_load_by_code(load_code)
    begin
      Load.find_by(code: load_code).nil? ? nil : Load.find_by(code: load_code).id
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'create_error', status: :unprocessable_entity
    end
  end
end
