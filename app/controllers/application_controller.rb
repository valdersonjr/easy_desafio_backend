class ApplicationController < ActionController::API

  private

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
