class LoadsController < ApplicationController
  # before_action :authenticate_user!
  # before_action :require_admin, only: [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    begin
      @q = Load.ransack(params[:q])
      @loads = @q.result(distinct: true)
      @loads = @loads.order(params[:sort]) if params[:sort].present?
      @loads = @loads.paginate(page: page, per_page: per_page)

      if @loads.any?
        pagination_meta(@loads)
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
      @load = Load.find_by(id: params[:id])
      if @load
        render 'show', status: :ok
      else
        @error_message = 'Load not found'
        render 'show_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'show_error', status: :not_found
    end
  end

  def create
    begin
      @load = Load.new
      @load.attributes = load_params
      @load.save!
      render 'create', status: :created
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'create_error', status: :unprocessable_entity
    end
  end

  def update
    begin
      @load = Load.find_by(id: params[:id])
      if @load
        if (@load.code == load_params[:code] || code_unique?(load_params[:code]))
          @load.update!(load_params)
          render 'update', status: :ok
        else
          @error_message = 'Code already exists in the database or you provided the same one'
          render 'update_error', status: :unprocessable_entity
        end

      else
        @error_message = 'Load not found'
        render 'update_error', status: :not_found
      end
    rescue ActiveRecord::RecordInvalid => error
      @error_message = error
      render 'update_error', status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @load = Load.find_by(id: params[:id])
      if @load
        @load.destroy
        render 'destroy', status: :ok
      else
        @error_message = 'Load not found'
        render 'destroy_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'destroy_error', status: :not_found
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
end
