class OpeningHoursController < ApplicationController
  def new
  end

  def edit
  	@weekday = OpeningHour.find_opening(params[:id])
  end 

  def update
  	@monday 	= Openinghours.find_day params[:id], "Monday"
  	@tuesday 	= Openinghours.find_day params[:id], "Tuesday"
  	@wednesday 	= Openinghours.find_day params[:id], "Wednesday"
  	@thursday 	= Openinghours.find_day params[:id], "Thursday"
  	@friday 	= Openinghours.find_day params[:id], "Friday"
  	@saturday 	= Openinghours.find_day params[:id], "Saturday"
  	@sunday 	= Openinghours.find_day params[:id], "Sunday"

  	weekdays = [@monday, @tueday, @wednesday, @thursday, @friday, @saturday, @sunday]
  	message = ""
  	weekdays.each do |day|
  		if day.save
  			message += "#{day} updated <br>"
  		else 
  			render 'edit'
  			# render :action => "new", :toilet => @toilet, :feedback => Feedback.new
  		end
  	end 

  	flash[:success] = message
  	redirect_to toilet_url
  end 

  def destroy
  end 

  private 
  	def monday_params 
  		params.require(:openingHours).permit(:comment, :cleanliness)
  	end 
  	def tuesday_params 
  	end 
  	def wednesday_params 
  	end 
  	def thursday_params 
  	end 
  	def friday_params 
  	end 
  	def saturday_params 
  	end 
  	def sunday_params 
  	end 




end
