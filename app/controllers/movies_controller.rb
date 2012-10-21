class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
		ratings = session[:ratings]
		if id.to_i == -1 then
     	@movies = Movie.order("title").where(:rating=>ratings.keys)
			@titleClass='hilite'
			@all_ratings = session[:all_ratings]
			session[:order]="title"
	  	render "app/views/movies/index.html.haml"
		elsif id.to_i == -2 then
			@movies = Movie.order("release_date").where(:rating=>ratings.keys)
			@dateClass='hilite'
			@all_ratings = session[:all_ratings]
			session[:order]="release_date"
			render "app/views/movies/index.html.haml"
    else
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    end
  end

  def index
		@all_ratings = Movie.select("rating").group("rating")
		ratings=params[:ratings]
		session_ratings = session[:all_ratings]

		if ratings == nil then
			if session_ratings == nil then
				@all_ratings.each do |rating|
					rating.rating = [rating.rating,true]
				end
    		@movies = Movie.where(:rating=>@all_ratings)
			else
				@all_ratings=session_ratings
				if session[:ratings]==nil then
					@movies = Movie.where(:rating=>@all_ratings)
				else			
					@movies = Movie.order(session[:order]).where(:rating=>session[:ratings].keys)
				end
			end
		else
			@all_ratings.each do |rating|
				if ratings[rating.rating]==nil then
					rating.rating = [rating.rating,false]
				else
					rating.rating = [rating.rating,true]
				end
			end
    	@movies = Movie.order(session[:order]).where(:rating=>ratings.keys)
		end
		session[:ratings]=ratings
		session[:all_ratings]=@all_ratings
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
