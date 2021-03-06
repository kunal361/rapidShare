class UsersController < ApplicationController

  before_filter :redirect_if_signed_in?, :only => [:new]
  before_filter :require_admin, :only => [:index, :destroy, :d_admin, :a_admin]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    name = params[:user][:name]
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.new({:name => name, :email => email, :password => password})
    if @user.save
      session[:user_id] = @user.id
      flash[:notice]="Sucessfully signed up..."
      redirect_to root_url
    else
      flash[:notice] = "Error signing up"
      render "new"
    end
  end

  def destroy
    if User.delete(params[:id]) != 0
      flash[:notice]="User Deleted"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_path
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
