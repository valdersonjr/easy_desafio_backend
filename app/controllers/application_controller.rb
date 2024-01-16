class ApplicationController < ActionController::API

  private

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      per_page: collection.per_page,
      total_entries: collection.total_entries,
      total_pages: collection.total_pages
    }
  end
end
