class OpeningHoursController < ApplicationController
  def new
  end

  def edit
  	@monday, @tuesday, @wednesday, @thursday, @friday, @saturday, @sunday = Openinghours.find_opening(params[:id])
  end 

  def update
  	@user = User.find params[:id]
    if @user.update user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end 

  def destroy
  end 

  private 
  	def monday_params 
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
