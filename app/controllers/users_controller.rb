class UsersController < ApplicationController

  before_filter :require_admin, :only => [:index, :destroy, :d_admin, :a_admin]

  def index
    @users = User.all
  end

  def new
  end

  def create
  end

  def destroy
    if User.delete(params[:id]) != 0
      flash[:notice]="User Deleted"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

  def a_admin
    if user = User.find_by_id(params[:id])
      user.change_role("admin")
      flash[:notice]="Admin Added"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_path
  end

  def d_admin
    if user = User.find_by_id(params[:id])
      user.change_role(nil)
      flash[:notice]="Admin removed"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_path
  end

end
