class LoadsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @loads = Load.paginate(page: page, per_page: per_page)

    if @loads.any?
      render json: {
        loads: LoadSerializer.new(@loads).serializable_hash,
        meta: pagination_meta(@loads)
      }, status: :ok
    else
        render json: { message: 'There is no existing load' }, status: :not_found
    end
  end

  def show
    @load = Load.find_by(id: params[:id])

    if @load
        render json: LoadSerializer.new(@load).serializable_hash
    else
        render json: { message: 'Load not found' }, status: :not_found
    end
  end

  def create
    @load = Load.new
    @load.attributes = load_params
    @load.delivery_date = parse_delivery_date(load_params[:delivery_date])
    save_load!
  end

  def update
    @load = Load.find_by(id: params[:id])

    if @load
        @load.update(load_params)
        render json: LoadSerializer.new(@load).serializable_hash, status: :ok
    else
        render json: { message: 'Load not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e }, status: :unprocessable_entity
  end

  def destroy
    @load = Load.find_by(id: params[:id])

    if @load
        @load.destroy
        render json: { message: 'Load deleted successfully' }, status: :ok
    else
        render json: { message: 'Load not found' }, status: :not_found
    end
  end

  private

  def load_params
    return {} unless params.has_key?(:load)
    params.require(:load).permit(:code, :delivery_date)
  end

  def save_load!
    @load.save!
    render json: { load: LoadSerializer.new(@load).serializable_hash }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e }, status: :unprocessable_entity
  end

  def parse_delivery_date(date_str)
    Date.strptime(date_str, '%d/%m/%y').strftime('%Y-%m-%d')
  end
end
