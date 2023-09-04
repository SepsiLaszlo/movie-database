class MovieApiClient
  URL = "https://api.themoviedb.org/3/search/movie"

  def self.search(query:, page: 1)
    api_key = Rails.application.credentials.themoviedb_api_key
    response = Faraday.get(URL, { query:, page: }, { 'Authorization': "Bearer #{api_key}" })
    JSON.parse(response.body)
  end
end