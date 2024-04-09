class CountsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @loads = Load.count
    @orders = Order.count
    @products = Product.count
    @users = User.count
    @pallets = Order.joins(:order_products).distinct.count

    render 'index', status: :ok
  end
end
