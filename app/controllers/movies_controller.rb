class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.ratings
    puts @all_ratings

    if params[:ratings]
      session[:ratings] = params[:ratings]
      @selected_ratings = params[:ratings]
    elsif session[:ratings]
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = Hash[@all_ratings.zip([1,1,1,1])]
    end

    sort = params[:sort_by]
    if params[:sort_by] == 'title'
      session[:sort_by] == 'title'
      
      #@title = 'hilite'
      @movies = Movie.order(sort).where(rating: @selected_ratings.keys)
    elsif params[:sort_by] == 'release_date'
      puts "Line 52"
      #@t = 'hilite'
      @movies = Movie.order('release_date').where(rating: @selected_ratings.keys)
    elsif session[:sort_by]
      redirect_to movies_path(sort: session[:sort_by], rating: @selected_ratings.keys)
    else
      @movies = Movie.where(rating: @selected_ratings.keys)
    
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

end
