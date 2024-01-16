class Users::UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        @users = User.paginate(page: page, per_page: per_page)

        if @users.any?
            render_json_response(nil, :ok, UserSerializer.new(@users).serializable_hash, pagination_meta(@users))
        else
            render_json_response('There is no existing user', :not_found)
        end
    end

    def show
        @user = User.find_by(id: params[:id])

        if @user
            render_json_response(nil, :ok, UserSerializer.new(@user).serializable_hash)
        else
            render_json_response('User not found', :not_found)
        end
    end
end
