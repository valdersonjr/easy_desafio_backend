class ApplicationController < ActionController::API

  private

  def render_json_response(message = nil, status = :ok,  data = nil, meta = nil)
    response_data = { code: status }
    response_data[:message] = message if message.present?
    response_data[:data] = data if data.present?
    response_data[:meta] = meta if meta.present?

    render json: response_data, status: status
  end

  def require_admin
    unless current_user.profile == 'admin'
      render json: { message: 'You cant perform this action with a client profile' }, status: :forbidden
      return
    end
  end

  def pagination_meta(collection)
    @pagination_meta = {
      current_page: collection.current_page,
      per_page: collection.per_page,
      total_entries: collection.total_entries,
      total_pages: collection.total_pages
    }
  end
end
