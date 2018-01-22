class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.ratings
    puts @all_ratings
      #puts "here is the output"
      #puts session[:sort]
      #sess = session[:sort]
      #sort = params[:sort]
      #order = nil

      #if sort == 'title' || sess == 'title'
      #  @title_header = 'hilite'
      #end
      #if sort == 'release_date' || sess == 'title'
      #  @date_header = 'hilite'
     # end

      #@movies = Movie.order(sort)
      #@all_ratings = Movie.ratings

      #if params[:ratings].present?
       # session[:filtered_ratings] = params[:ratings]
        #@movies = Movie.where(:rating => session[:filtered_ratings].keys)




    if params[:ratings]
      session[:ratings] = params[:ratings]
      @selected_ratings = params[:ratings]
    elsif session[:ratings]
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = Hash[@all_ratings.zip([1,1,1,1])]
    end

    sort = params[:sort]
    if params[:sort] == 'title'
      session[:sort] == 'title'
      
      @title = 'hilite'
      @movies = Movie.order(sort).where(rating: @selected_ratings.keys)
    elsif params[:sort] == 'release_date'
      puts "Line 52"
      @t = 'hilite'
      @movies = Movie.order('release_date').where(rating: @selected_ratings.keys)
    elsif session[:sort]
      redirect_to movies_path(sort: session[:sort], rating: @selected_ratings.keys)
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
