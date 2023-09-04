Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/search_in_memory', to: 'movies#search_in_memory', as: :search_in_memory
  get '/search_in_database', to: 'movies#search_in_database', as: :search_in_database
  root "movies#search_in_memory"
end
