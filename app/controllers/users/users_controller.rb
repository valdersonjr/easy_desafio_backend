class Users::UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        @q = User.ransack(params[:q])
        @users = @q.result.paginate(page: page, per_page: per_page)

        if @users.any?
          render_json_response(nil, :ok, @users, pagination_meta(@users))
        else
          render_json_response('There is no existing user', :not_found)
        end
      end

    def show
        @user = User.find_by(id: params[:id])
debugger
        if @user
            render_json_response(nil, :ok, @user)
        else
            render_json_response('User not found', :not_found)
        end
    end
end
