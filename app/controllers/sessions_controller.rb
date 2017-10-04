class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)

    if user
    # if user && user.authenticate(params[:session][:password])
    flash.now[:danger] = user.email
      log_in user
      redirect_to root_url
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
