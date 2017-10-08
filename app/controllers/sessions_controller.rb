class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email].downcase)

    if @user && @user.password == params[:session][:password]
      log_in @user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    @user = nil
    log_out
    redirect_to root_url
  end

  private 
  def user_email_param
    params.require(:user).permit(:email).downcase
  end 

end
