class Users::SessionsController < Devise::SessionsController
  include RackSessionFix

  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render_json_response('Logged in successfully', :ok, current_user)
  end

  def respond_to_on_destroy
    if current_user
      render_json_response('Logged out successfully', :ok)
    else
      render_json_response("Couldn't find an active session.", :unauthorized)
    end
  end
end
