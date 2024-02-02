class LoadsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @q = Load.ransack(params[:q])
    @loads = @q.result(distinct: true)
    @loads = @loads.order(params[:sort]) if params[:sort].present?
    @loads = @loads.paginate(page: page, per_page: per_page)

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
    save_load!
  end

  def update
    @load = Load.find_by(id: params[:id])

    if @load
      if (@load.code == load_params[:code] || code_unique?(load_params[:code]))
        @load.update(load_params)
        render_json_response(nil, :ok, @load, nil)
      else
        render_json_response('Code already exists in the database or you provided the same one', :unprocessable_entity, nil, nil)
      end
    else
      render_json_response('Load not found', :not_found, nil, nil)
    end
  rescue ActiveRecord::RecordInvalid => e
    render_json_response(e, :unprocessable_entity, nil, nil)
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

  def code_unique?(code)
    !Load.exists?(code: code)
  end

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
end
