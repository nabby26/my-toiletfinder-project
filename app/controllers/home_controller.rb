class HomeController < ApplicationController
	PER_PAGE = 200

	def index
		@toilets , @cursor = Toilet.query limit: PER_PAGE, cursor: params[:cursor], cursor: params[:cursor]
		@public_data_toilets = Toilet.new.get_public_toilets
	end
end
