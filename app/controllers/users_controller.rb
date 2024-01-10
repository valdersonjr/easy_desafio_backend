class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.all
        render json: UserSerializer.new(@users).serializable_hash
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