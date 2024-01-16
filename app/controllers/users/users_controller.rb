class Users::UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        @users = User.paginate(page: page, per_page: per_page)

        if @users.any?
            render json: {
                users: UserSerializer.new(@users).serializable_hash,
                meta: pagination_meta(@users)
            }, status: :ok
        else
            render json: { message: 'There is no existing user' }, status: :not_found
        end
    end

    def show
        @user = User.find_by(id: params[:id])

        if @user
            render json: UserSerializer.new(@user).serializable_hash
        else
            render json: { error: 'User not found' }, status: :not_found
        end
    end
end
