class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  include RackSessionFix
  
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save

    if resource.persisted?
        render json: { code: 200, message: 'Signed up successfully', data: resource }, status: :ok

    else
      render json: { message: 'User could not be created successfully', errors: resource.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if current_user.profile == "admin"
      if params[:id]
        begin
          scoped_user = User.find(params[:id])
          update_user(scoped_user)
        rescue
          render json: { code: 422, message: 'User with this id was not found' }, status: :unprocessable_entity
        end
      else
        update_user(current_user)
      end
    elsif current_user.profile == "client"
      update_user(current_user)
    else
      render json: { message: 'Unauthorized', errors: ['You do not have permission to update users.'] }, status: :unauthorized
    end
  end

  def destroy
    resource.destroy
    render json: { code: 200, message: 'User deleted successfully', data: resource }, status: :ok
  end

  private

  def update_user(user)
    if user.update(account_update_params)
      render json: { code: 200, message: 'Updated successfully', data: user }, status: :ok
    else
      render json: { message: 'User could not be updated', errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
  end
end
