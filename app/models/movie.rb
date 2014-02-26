class Movie < ActiveRecord::Base
	def self.all_ratings
		ratings = Movie.find(:all, :select => 'rating', :group => 'rating').map(&:rating)
	end
	def self.sort_movies(params)
		Movie.find(:all, :order => params)
	end
	def self.filter(ratings)
		Movie.find(:all, :conditions=>{:rating => ratings})
	end
	def self.sort_movies_with_filter(ratings, params)
		Movie.find(:all, :order => params, :conditions=>{:rating => ratings})
	end
end
