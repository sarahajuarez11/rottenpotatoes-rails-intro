class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings

    @checked_ratings = params[:ratings] if params.has_key? 'ratings'
    @ordered_by = params[:order_by] if params.has_key? 'order_by'

    # session.clear where user submit empty rating filters
    if params.has_key? 'utf8'
      session.delete :checked_ratings
      session.delete :ordered_by
    end

    # update session from incoming params
    session[:checked_ratings] = @checked_ratings if @checked_ratings
    session[:ordered_by] = @ordered_by if @ordered_by

    if !@checked_ratings && !@ordered_by && session[:checked_ratings]
      @checked_ratings = session[:checked_ratings] unless @checked_ratings
      @ordered_by = session[:ordered_by] unless @ordered_by

      flash.keep
      redirect_to movies_path({order_by: @ordered_by, ratings: @checked_ratings})
    end

    if @checked_ratings
      if @ordered_by      
        @movies = Movie.find_all_by_rating(@checked_ratings, :order => "#{@ordered_by} asc")
      else
        @movies = Movie.find_all_by_rating(@checked_ratings)
      end
    elsif @ordered_by
      @movies = Movie.all(:order => "#{@ordered_by} asc")
    else 
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  # find movies with same director
  def same_director
    movie = Movie.find(params[:id])
    director_name = movie.director
    
    if not director_name or director_name.empty?
      flash[:notice] = %Q{'#{movie.title}' has no director info}
      redirect_to movies_path
    else
      @movies = Movie.find_all_by_director director_name
      flash[:notice] = %Q{There are #{@movies.size} movie(s) with "#{director_name}" as director}
    end
  end

end
