class CountsController < ApplicationController
  # before_action :authenticate_user!

  def index
    counts = {
      loads: Load.count,
      users: User.count,
      products: Product.count
    }

    render_json_response(nil, :ok, counts)
  end
end
