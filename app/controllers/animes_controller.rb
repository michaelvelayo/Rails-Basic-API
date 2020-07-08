class AnimesController < ApplicationController

	# GET /animes
	def index
		animes = Anime.all
		render json: animes
	end

	# GET /animes/:id
	def show
		anime = Anime.find(params[:id])
		render json: anime
	end

	# POST /animes
	def create
		byebug
		anime = Anime.new(anime_params)
		if anime.save

		else

		end
	end

	# PATCH /animes/:id
	def update

	end

	# DELETE /animes/:id
	def destroy

	end

	private

	def anime_params
		params.require(:anime).permit(:english,:synonyms,:japanese)
	end

end
