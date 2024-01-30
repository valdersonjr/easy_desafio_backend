class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  include RackSessionFix

  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save

    if resource.persisted?
      render_json_response('Signed up successfully', :ok, resource)

    else
      render_json_response(['User could not be created successfully']+resource.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    if current_user.profile == "admin"
      if params[:id]
        begin
          scoped_user = User.find(params[:id])
          update_user(scoped_user)
        rescue ActiveRecord::RecordNotFound => e
          render_json_response(e, :unprocessable_entity)
        end
      else
        update_user(current_user)
      end
    elsif current_user.profile == "client"
      if params[:user][:profile].present? && !(params[:user][:profile] == "client" || params[:user][:profile] == 1)
        render_json_response('Clients are not allowed to update the profile field.', :unauthorized)
      else
        update_user(current_user)
      end
    else
      render_json_response('You do not have permission to update users.', :unauthorized)
    end
  end

  def destroy

    if params[:id].present?
      begin
        scoped_user = User.find(params[:id])
        if(scoped_user)
          scoped_user.destroy
          render_json_response('User deleted successfully', :ok, scoped_user)
        else
          render_json_response('User not found', :not_found)
        end
      rescue ActiveRecord::RecordNotFound => e
        render_json_response(e, :unprocessable_entity)
      end
    else
      resource.destroy
      render_json_response('User deleted successfully', :ok, resource)
    end
  end

  private

  def update_user(user)
    if user.update(account_update_params)
      render_json_response('Updated successfully', :ok, user)
    else
      render_json_response(['User could not be updated']+user.errors.full_messages, :unprocessable_entity)
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
