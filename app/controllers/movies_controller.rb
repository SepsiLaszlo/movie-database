class MoviesController < ApplicationController
  def search_in_memory
    search_url = ->(**args) { search_in_memory_url(args) }
    render_search_with(MoviesClientWithRailsCache, search_url)
  end

  def search_in_database
    search_url = ->(**args) { search_in_database_url(args) }
    render_search_with(MoviesClient, search_url)
  end

  private

  def render_search_with(search_client, search_url)
    cache_entry = search_client.search(**movie_params)
    @cache_hit_count = cache_entry.hit_count
    @page = cache_entry.page
    @query = cache_entry.query
    @total_pages = cache_entry.total_pages
    @movies = cache_entry.movies
    @search_url = search_url
    render 'search'
  end

  def movie_params
    { query: params[:query]&.downcase, page: params[:page] || 1 }
  end
end
