class OpeningHoursController < ApplicationController
  def new
  end

  def edit
  	@weekday = OpeningHour.find_opening(params[:toilet])
  end 

  def update
  	message = ""
  	params["weekday"].each do |day|
	    if params["weekday"][day]["open_time"] != "" || params["weekday"][day]["open_time"] != ""
	    	@weekday = OpeningHour.find_day(toilet_id: params["weekday"][day][:toilet_id], weekday: params["weekday"][day][:day])
	    	if @weekday.update(weekday_params(params["weekday"][day]))
	    		message += "#{params["weekday"][day][:day]} updated, "
	    	else 
  				render 'edit'
	    	end 
	    end
  	end

  	flash[:success] = message
  	redirect_to root_url
  end 

  def destroy
  end 

  private 
  	def weekday_params params 
  		params.permit(:open_time, :close_time)
  	end 
end
