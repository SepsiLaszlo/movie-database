module ApplicationHelper
  def pagination_page_numbers(current_page:, total_pages:)
    pagination_pages = []
    nearby_pages = ((current_page - 4)..(current_page + 4)).sort_by { |page| (current_page - page).abs }
    nearby_pages.each do |page|
      pagination_pages << page if 0 < page && page <= total_pages && pagination_pages.length < 5
    end
    pagination_pages.sort
  end
end
