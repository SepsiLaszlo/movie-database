##
# This class responsible to process movies list
class MoviesClient
  private attr_reader :query, :page, :cache_entry

  def initialize(query:, page: 1)
    @query = query
    @page = page
    @cache_entry = CacheEntry.find_by(query:, page:)
  end

  def self.search(params)
    new(**params).search
  end

  def search
    return empty_cache_entry if query.blank?
    return new_cache_entry if cache_entry.blank?

    cache_entry.with_lock do
      if cache_entry.is_valid?
        cache_entry_with_incremented_counter
      else
        updated_cache_entry
      end
    end
  end

  def new_cache_entry
    response = request_movie_search(query:, page:)
    cache_entry = CacheEntry.new
    cache_entry.save_with_counter_reset!(query:, page:,
                                         movies: response['results'],
                                         total_pages: response['total_pages'])
    cache_entry
  end

  def updated_cache_entry
    response = request_movie_search(query:, page:)
    cache_entry.save_with_counter_reset!(movies: response['results'],
                                         total_pages: response['total_pages'])
    cache_entry
  end

  def cache_entry_with_incremented_counter
    cache_entry.increment!(:hit_count)
    cache_entry
  end

  def empty_cache_entry
    CacheEntry.new(query:, page: 1, total_pages: 1, hit_count: 0, expires_at: Time.current, movies: [])
  end

  def request_movie_search(query:, page:)
    MovieApiClient.search(query:, page:)
  end
end
