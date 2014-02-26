class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings= Movie.all_ratings
    @ratings=Hash[@all_ratings.map { |e| [e, 1] }] # Initialize ratings to contain all ratings in hash.
    @movies = Movie.all
    keys=@all_ratings
    redirect= false
    # This is for checking whether there is params[:ratings] or session[:ratings] exists.
    if params[:ratings]
      @ratings=params[:ratings]
    else #If the params does not exist, it doesn't mean that the session doesn't exist.
      if session[:ratings] #If the session exist, it means that those movies have already filtered, and the page should keep the feature
        @ratings=session[:ratings]
        # If the session exist, the action should be redirected. There are two conditions:
        #  1) The action came from index page.
        # 2) The action came from show page.
        redirect=true 
      end
    end

    if params[:sort] # Check whether params[:sort] has been set.
      @sort=params[:sort]
    else # If the params does not exist, it doesn't mean that the session doesn't exist.
      if session[:sort] # Check session
        @sort=session[:sort]
        # If the session exist, the action should be redirected. There are two conditions:
        #  1) The action came from index page.
        # 2) The action came from show page.
        redirect=true
      end
    end

    if redirect # If the action can be redirected.
      # Two conditions:
      # 1) The action came from index page: the page will be redirected to the same page but with two params,
      # which means that the method can get both of the params and keep the original features.
      # 2) The action came from show page: same as the previous one, the feature will be kept by sessions, and 
      # be converted to params after redirection.
      redirect_to movies_path(:ratings => @ratings, :sort => @sort)
    end

    # If ratings is not empty.
    if !@ratings.empty?
      keys=@ratings.keys
      # Call fileter in class Movie to get the movies with those ratings.
      @movies=Movie.filter(keys)
      session[:ratings]=@ratings # Store the ratings into session.
    end
    
    if @sort # Check whether params[:sort] has been set.
      if !@ratings.empty? # If @ratings exists, it means that the action sort must consider those filtered movies.
        # Call sort_movies_with_filter is for getting the sorted movies that have been filtered.
        @movies = Movie.sort_movies_with_filter(keys, @sort) 
      else # If @ratings doesn't exist, it means that "sort" doesn't need to consider of filter.
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
