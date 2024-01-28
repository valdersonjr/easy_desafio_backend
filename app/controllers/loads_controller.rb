class LoadsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @loads = Load.paginate(page: page, per_page: per_page)

    if @loads.any?
      render_json_response(nil, :ok, @loads, pagination_meta(@loads))
    else
      render_json_response('There is no existing load', :not_found, nil, nil)
    end
  end

  def show
    @load = Load.find_by(id: params[:id])

    if @load
        render_json_response(nil, :ok, @load, nil)
    else
        render_json_response('Load not found', :not_found, nil, nil)
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
        render_json_response(nil, :ok, @load, nil)
    else
        render_json_response('Load not found', :not_found, nil, nil)
    end
  rescue ActiveRecord::RecordInvalid => e
    render_json_response(e, :not_found, nil, nil)
  end

  def destroy
    @load = Load.find_by(id: params[:id])

    if @load
        @load.destroy
        render_json_response('Load deleted successfully', :ok, nil, nil)
    else
        render_json_response('Load not found', :not_found, nil, nil)
    end
  end

  private

  def load_params
    return {} unless params.has_key?(:load)
    params.require(:load).permit(:code, :delivery_date)
  end

  def save_load!
    @load.save!
    render_json_response(nil, :created, @load, nil)
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e }, status: :unprocessable_entity
  end

  def parse_delivery_date(date_str)
    Date.strptime(date_str, '%d/%m/%y').strftime('%Y-%m-%d')
  end
end
