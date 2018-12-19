require 'pry'
class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def create
    @movie = Movie.new(movie_params)

    @movie.image_url = movie_params["image_url"].slice(31..-1)

    if @movie.save
      flash[:success] = "Your movie #{@movie.title} has been added"
      render status: :ok, json: data
      redirect_to :root
      redi
    end
    #
    #
    # else
    #   render status: :bad_request, json: data
    # end

  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :release_date, :inventory, :image_url, :external_id)
  end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
