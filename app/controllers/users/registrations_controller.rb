class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    build_resource(sign_up_params)
    resource.save
    @user = resource

    if @user.errors.any?
      render 'create_error', status: :unprocessable_entity
    else
      render 'create', status: :created
    end
  end

  def update
    if current_user && current_user.profile != "admin"
      if params[:user][:profile].present? && current_user.profile != params[:user][:profile]
        @error_message = 'You are not allowed to update the profile field.'
        render 'update_error', status: :unauthorized
      else
        update_user?(current_user) ? (render 'update', status: :ok) : (render 'update_error', status: :unprocessable_entity)
      end
    else
      update_user?(current_user) ? (render 'update', status: :ok) : (render 'update_error', status: :unprocessable_entity)
    end
  end

  def update_user_by_id
    if current_user.profile != "admin"
      @error_message = 'You do not have permission to update users.'
      render 'update_user_by_id_error', status: :unauthorized
    else
      begin
        scoped_user = User.find(params[:id])
        update_user?(scoped_user) ? (render 'update_user_by_id', status: :ok) : (render 'update_user_by_id_error', status: :unprocessable_entity)
      rescue ActiveRecord::RecordNotFound => error
        @error_message = error
        render 'update_user_by_id_error', status: :not_found
      end
    end
  end

  def destroy
    begin
      resource.destroy
      render 'destroy', status: :ok
    rescue StandardError => error
      render 'destroy_error', status: :unprocessable_entity
    end
  end

  def destroy_user_by_id
    if current_user.profile != "admin"
      @error_message = 'You do not have permission to delete users.'
      render 'destroy_user_by_id_error', status: :unauthorized
    else
      begin
        scoped_user = User.find(params[:id])
        if(scoped_user)
          @id = scoped_user.id
          scoped_user.destroy
          render 'destroy_user_by_id', status: :ok
        end
      rescue ActiveRecord::RecordNotFound => error
        @error_message = error
        render 'destroy_user_by_id_error', status: :not_found
      end
    end
  end

  private

  def update_user?(user)
    if user.update(account_update_params)
      @user = user
      return true
    else
      @error_message = user.errors.full_messages
      return false
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
