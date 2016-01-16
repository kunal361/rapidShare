class ApplicationController < ActionController::Base

  protect_from_forgery
  helper_method :current_user

  def current_user
     @current_user ||= Users.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to login_url unless current_user
  end

  def require_admin
    redirect_to root_url unless current_user && current_user.admin?
  end

end
