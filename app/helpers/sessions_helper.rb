module SessionsHelper
# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user = User.find session[:user_id]
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

    # Logs out the current user.
  def log_out
    session[:user_id] = nil
    @current_user = nil
  end
end
