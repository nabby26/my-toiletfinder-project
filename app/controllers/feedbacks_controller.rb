class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
    @toilet = Toilet.find(params[:toilet])
  end


  def create
    @user_id = session[:user_id]
    @toilet_id = params[:feedback][:toilet_id]
    if @toilet_id == nil
      flash[:success] = "Toilet cannot be found"
      redirect_to root_url
    end
    @toilet = Toilet.find(@toilet_id)
    # Need to calculate overall rating
    @feedback = Feedback.new(feedback_params.merge(overall: 5, user_id: @user_id, toilet_id: @toilet_id))
    if @feedback.save
      flash[:success] = "Commented"
      redirect_to toilet_path(@toilet_id)
    else
      render :action => "new", :toilet => @toilet
    end
  end 

  def calculate_overall_rating
  end

  def edit
  end 

  def update
  end 

  def destroy
  end 

  private

  def feedback_params
    params.require(:feedback).permit(:comment, :cleanliness, :odour, :safety)
  end
end
