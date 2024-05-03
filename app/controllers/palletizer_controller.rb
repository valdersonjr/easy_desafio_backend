require_relative '../helpers/palletizer_helper'

class PalletizerController < ApplicationController
  include Palletizer

  # load code will come from body of the request
  def run_palletizer
    palletizer(params[:load_code])
    render 'index', status: :ok
  end
end
