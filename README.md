# README

The projects aims to implement a simple cache service
for [The Movie Database search API](https://developer.themoviedb.org/reference/search-movie), with a minimalist UI.

## Features

- Users can search movies with pagination and a cache hit counter
- Two types of cache solution:
    - In memory search, implemented using Rails own caching solution
    - In database search, a custom built cache solution, which uses PostgreSQL to store data
- Responsive UI optimized for both mobile and desktop experience
- Error handling, the user will see an error page if the API is not reachable
- Tests for both cache solutions
- Create Docker, docker-compose and nginx config to deploy the application to https://www.movie-database.kir-dev.sch.bme.hu

## Future improvements

- Use Redis for cache server
- Clean up CSS files, consider using a CSS framework like [TailwindCSS](https://tailwindcss.com/)
- Add System/UI test, mock network requests during testing, measure code coverage, add CI workflows for test automation
- Make movie cards clickable, open a movie details page on click
- Cache statistics page, where users could see the most popular search terms

## Deployment

1. Copy the master.key to the config folder of the project from a safe storage.

2. Create docker volumes for the application

```bash
docker volume create movie_database_db
```

3. Set up the `.posgtres_password` file. Copy the the `.postgres_password.example` file into `.postgres_password`. Then
   set the `POSTGRES_PASSWORD` environment variable to be the same as `Rails.application.credentials.postgres_password`.

```bash
cp .postgres_password.example .postgres_password
```

4. Start the aplication

```bash
docker compose up -d
```

5. Setup the database

```bash
 docker compose exec web rails db:setup
```



