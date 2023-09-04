##
# This class responsible to process movies list
class MoviesClientWithRailsCache
  private attr_reader :query, :page, :cache_entry, :cache_entry, :cache_entry_hit_count

  def initialize(query:, page: 1)
    @query = query
    @page = page.to_i
    @cache_entry = Rails.cache.read(cache_entry_key)
    @cache_entry_hit_count = Rails.cache.read(cache_entry_hit_count_key)
  end

  def self.search(params)
    new(**params).search
  end

  def search
    return empty_cache_entry if query.blank?
    return new_cache_entry if cache_entry.blank?

    cache_entry_with_incremented_counter
  end

  def cache_entry_with_incremented_counter
    Rails.cache.increment(cache_entry_hit_count_key)

    OpenStruct.new(query:, page:,
                   total_pages: cache_entry['total_pages'],
                   hit_count: cache_entry_hit_count + 1, expires_at: Time.current + CACHE_DURATION,
                   movies: cache_entry['results'])
  end

  def new_cache_entry
    new_entry = request_movie_search(query:, page:)
    Rails.cache.write(cache_entry_key, new_entry, expires_in: CACHE_DURATION)
    Rails.cache.write(cache_entry_hit_count_key, 0, expires_in: CACHE_DURATION)

    OpenStruct.new(query:, page:,
                   total_pages: new_entry['total_pages'],
                   hit_count: 0, expires_at: Time.current + CACHE_DURATION,
                   movies: new_entry['results'])
  end

  def empty_cache_entry
    OpenStruct.new(query:, page: 1, total_pages: 1, hit_count: 0, expires_at: Time.current, movies: [])
  end

  def cache_entry_key
    "#{query}-#{page}"
  end

  def cache_entry_hit_count_key
    "#{cache_entry_key}-hit-count"
  end

  def request_movie_search(query:, page:)
    MovieApiClient.search(query:, page:)
  end
end
