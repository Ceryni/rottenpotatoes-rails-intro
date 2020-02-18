class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    @titleOrdered = false
    @dateOrdered = false
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    if params[:orderby] == 'title'
      @movies = Movie.order(:title).where(rating: selected_ratings)
      @titleOrdered = true
    elsif params[:orderby] == 'release_date'
      @movies = Movie.order(:release_date).where(rating: selected_ratings)
      @dateOrdered = true
    else
      @movies = Movie.all.where(rating: selected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def selected_ratings
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end
end
