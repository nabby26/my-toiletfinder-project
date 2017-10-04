class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email].downcase)
    if (!@user)
      flash.now[:danger] = params[:session][:email]
    end 
    if @user && (@user.password == params[:session][:password])
    # if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      # flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
