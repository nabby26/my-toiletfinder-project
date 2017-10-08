class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(session[:user_id])
  end 

  def settings 
    # @user = User.find(params[:id])
  end 

  def create
    @user = User.new user_params
    @check_user = User.find_by_email(params[:user][:email].downcase)
    if @check_user
      flash[:danger] = "An account already exsits with this email"
      render 'new'
    else 
      if @user.save
        log_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to root_url
      else
        render 'new'
      end
    end 
  end

  def edit
    @user = User.find(params[:id])
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
    @user = User.find(session[:user_id])
    log_out
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
