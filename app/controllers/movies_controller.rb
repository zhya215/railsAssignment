class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings= Movie.all_ratings
    @ratings={}
    @movies = Movie.all
    keys=[]
    redirect= false
    # This is for checking whether there is params[:ratings] or session[:ratings] exists.
    if params[:ratings]
      @ratings=params[:ratings]
    else
      if session[:ratings]
        @ratings=session[:ratings]
        redirect=true
      end
    end

    if params[:sort] # Check whether params[:sort] has been set.
      @sort=params[:sort]
    else
      if session[:sort]
        @sort=session[:sort]
        redirect=true
      end
    end

    if redirect
      redirect_to movies_path(:ratings => @ratings, :sort => @sort)
    end

    # If ratings is not empty.
    if !@ratings.empty?
      keys=@ratings.keys
      @movies=Movie.filter(keys)
      session[:ratings]=@ratings
    end
    
    if @sort # Check whether params[:sort] has been set.
      if !@ratings.empty?
        @movies = Movie.sort_movies_with_filter(keys, @sort) # get sorted and filtered movies.
      else
        @movies= Movie.sort_movies(@sort)# get sorted movies.
      end
      session[:sort]=@sort
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
