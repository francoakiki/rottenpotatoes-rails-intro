class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings

      if params[:ratings].nil? && session[:ratings].nil?
        @ratings_to_show = @all_ratings
      else
        if session[:ratings] != params[:ratings] or session[:ratings].nil?
          session[:ratings] = params[:ratings]
        end
        @ratings_to_show = session[:ratings].keys
      end

      if params[:sort] == 'title' or session[:sort] == 'title'
        if session[:sort] != params[:sort]
          session[:sort] = params[:sort]
        end
        @title_header = 'bg-warning'
        @movies = Movie.with_ratings(@ratings_to_show).order('title')
      elsif params[:sort] == 'release_date' or session[:sort] == 'release_date'
        if session[:sort] != params[:sort]
          session[:sort] = params[:sort]
        end
        @release_date_header = 'bg-warning'
        @movies = Movie.with_ratings(@ratings_to_show).order('release_date')
      else
        @movies = Movie.with_ratings(@ratings_to_show)
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end