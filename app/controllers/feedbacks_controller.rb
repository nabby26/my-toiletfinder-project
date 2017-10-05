class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
    @toilet = Toilet.find(params[:toilet])
  end


  def create
    @user_id = session[:user_id]
    @toilet_id = params[:feedback][:toilet_id]
    @toilet = Toilet.find(@toilet_id)
    @feedback = Feedback.new(feedback_params.merge(user_id: @user_id, toilet_id: @toilet_id))
    if @feedback.save
      flash[:success] = "Commented"
      redirect_to toilet_path(@toilet_id)
    else
      render :action => "new", :toilet => @toilet, :feedback => Feedback.new
    end
  end 

  def edit
  end 

  def update
  end 

  def destroy
  end 

  private

  def feedback_params
    # calculating overall rating
    cleanliness = params[:feedback][:cleanliness].to_i
    odour = 6 - params[:feedback][:odour].to_i
    safety = params[:feedback][:safety].to_i

    overall = (cleanliness + odour + safety).to_f/3


    params.require(:feedback).permit(:comment, :cleanliness, :odour, :safety).merge(overall: overall)
  end
end
