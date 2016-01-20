class ApplicationController < ActionController::Base

  protect_from_forgery

  def require_admin
    redirect_to root_url unless current_user && current_user.admin?
  end

end
