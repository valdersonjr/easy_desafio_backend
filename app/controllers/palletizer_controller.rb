class PalletizerController < ApplicationController
  
  def run_palletizer
    PalletizerJob.perform_later(params[:load_code])
    # PalletizerWorker.perform_async(params[:load_code])
    render 'index', status: :ok
  end
end
