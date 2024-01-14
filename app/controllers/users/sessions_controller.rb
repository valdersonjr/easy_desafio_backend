class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  
  respond_to :json

  private
  
  def respond_with(current_user, _opts = {})
    render json: { code: 200, message: 'Logged in successfully.', data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }}, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { code: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { code: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
