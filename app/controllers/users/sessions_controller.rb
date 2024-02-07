class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, only: [:validate_session]

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    @user = resource
    @user.errors.any? ? (render 'create_error', status: :unauthorized) : (render 'create', status: :created)
  end

  def respond_to_on_destroy
    if current_user
      render 'respond_to_on_destroy', status: :ok
    else
      @error_message = 'Couldn\'t find an active session.'
      render 'respond_to_on_destroy_error', status: :unprocessable_entity
    end
  end

  def validate_session
    if current_user
      render 'validate_session', status: :ok
    else
      @error_message = 'Couldn\'t find an active session.'
      render 'validate_session_error', status: :unprocessable_entity
    end
  end
end
