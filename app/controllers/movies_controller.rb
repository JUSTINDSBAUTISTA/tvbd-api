require "httparty"

class MoviesController < ApplicationController
  API_BASE_URL = "https://api4.thetvdb.com/v4/movies"
  API_AUTH_HEADER = {
    "Accept" => "application/json",
    "Authorization" => "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2UiOiIiLCJhcGlrZXkiOiIzZGE5MjUwNi0wMDIzLTQwMGMtOTc5ZS05MTllZDdhZTgxOTEiLCJjb21tdW5pdHlfc3VwcG9ydGVkIjpmYWxzZSwiZXhwIjoxNzI4NzM0NzkwLCJnZW5kZXIiOiIiLCJoaXRzX3Blcl9kYXkiOjEwMDAwMDAwMCwiaGl0c19wZXJfbW9udGgiOjEwMDAwMDAwMCwiaWQiOiIyNDc1Njc5IiwiaXNfbW9kIjpmYWxzZSwiaXNfc3lzdGVtX2tleSI6ZmFsc2UsImlzX3RydXN0ZWQiOmZhbHNlLCJwaW4iOm51bGwsInJvbGVzIjpbXSwidGVuYW50IjoidHZkYiIsInV1aWQiOiIifQ.f4Xs2uZ570d1nSwJWQeN4OEvm2JoIHkQyxHMddV3Xc8WjwdVTgyOAVWK4eD1PxBHuAhjjryb-TwpiKUyclBuu1dMOZg-1S0mulkjcBsq15vyz2d_Fg5iNJgErD7Cjqu-cY7NH1qsF6BUv5sdAZDxu3ntce1ZcWCQzPatbAplDQ7JwtcpEFtOhWXlPZqbRwui0wGZ7bY9eTqGOQJzXCLzSCzM6B3US9ZswBmYtz7_Z-Kk4U9biWDA5g-UdGSuOnmjw7mNvQZmhCk51Hmx3ptr7gkXVN-RkXVq3AfFxF5M0DEtOktZOQ5C2N6xLhwk1EnFfoIZjJz-KDJPSZ3MtwgsFDuTM3CNgXKnspmwz5b67cVHdwOCs46GXJ48MNIsgiwYouTfjGEUSHJJElG055pQZt2PVF3bdc9g_cZkrXOTttT7Xvl3njNy81xBulUS8fKJZjhckAJJSZZwQHbOECTR50LJWQT9-qJSTiZgIfDi9qtmHU0jUpJccHMZVASQItyjzokm5dTkNtAqT-eLzZO-3LSoB1r9ubzmGh6PyQEL3bOvfgyNEMiGHqXyV39D_sS5a8Jyp2HoOlzWjyStBkWurWhBP6-7WT218dY6uDhA_4TlD2_wJodeuEF1T1udwOKYWKjxV8lhTR7HLPebqfSeBGeEsV4bSD4dngILMFRl0zM"
  }

  # GET /movies
  def index
    search_term = params[:search].to_s.downcase
    response = HTTParty.get(API_BASE_URL, headers: API_AUTH_HEADER)
    all_movies = response.parsed_response["data"]

    if search_term.present?
      @movies = all_movies.select { |movie| movie["name"].downcase.include?(search_term) }
    else
      @movies = all_movies
    end
  end

  # GET /movies/:id
  def show
    response = HTTParty.get("#{API_BASE_URL}/#{params[:id]}", headers: API_AUTH_HEADER)
    @movie = response.parsed_response["data"]
  end

  # POST /movies
  def create
    response = HTTParty.post(API_BASE_URL, body: movie_params.to_json, headers: API_AUTH_HEADER.merge("Content-Type" => "application/json"))
    @movie = response.parsed_response
    render json: @movie, status: :created
  end

  # PUT/PATCH /movies/:id
  def update
    response = HTTParty.put("#{API_BASE_URL}/#{params[:id]}", body: movie_params.to_json, headers: API_AUTH_HEADER.merge("Content-Type" => "application/json"))
    @movie = response.parsed_response
    render json: @movie
  end

  # DELETE /movies/:id
  def destroy
    HTTParty.delete("#{API_BASE_URL}/#{params[:id]}", headers: API_AUTH_HEADER)
    head :no_content
  end

  private

  # Only allow a trusted parameter "white list" through.
  def movie_params
    params.require(:movie).permit(:name, :slug, :image, :name_translations, :overview_translations, :aliases, :score, :runtime, :status_id, :status_name, :status_record_type, :status_keep_updated, :last_updated, :year)
  end
end
