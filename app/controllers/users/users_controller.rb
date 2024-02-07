class Users::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    begin
      @q = User.ransack(params[:q])
      @users = @q.result
      @users = @users.order(params[:sort]) if params[:sort].present?
      @users = @users.paginate(page: page, per_page: per_page)

      if @users.any?
        pagination_meta(@users)
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
      @user = User.find_by(id: params[:id])
      if @user
        render 'show', status: :ok
      else
        @error_message = 'User not found'
        render 'show_error', status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => error
      @error_message = error
      render 'show_error', status: :not_found
    end
  end
end
