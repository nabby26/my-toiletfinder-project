class HomeController < ApplicationController
	PER_PAGE = 4

	def index
		@toilets , @cursor = Toilet.query limit: PER_PAGE, cursor: params[:cursor], cursor: params[:cursor]
	end
end
