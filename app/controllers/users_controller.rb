class UsersController < ApplicationController

  before_filter :redirect_if_signed_in?, :only => [:new]
  before_filter :require_admin, :only => [:index, :destroy, :d_admin, :a_admin]

  def index
    @users = User.all
  end

  def new
  end

  def create
    name = params[:user][:name]
    email = params[:user][:email]
    password = params[:user][:password]
    user = User.new({:name => name, :email => email, :password => password})
    if user.save
      session[:user_id] = user.id
      flash[:notice]="Sucessfully signed up..."
      redirect_to root_url
    else
      errors = user.errors.full_messages
      puts errors
      flash[:notice] = ""
      errors.each do |error|
        flash[:notice] += "#{error}. "
      end
      redirect_to signup_url
    end
  end

  def destroy
    begin
      if User.delete(params[:id]) != 0
        flash[:notice]="User Deleted"
      else
        flash[:notice]="No Such User"
      end
    rescue
      flash[:notice]="Error Deleting User"
    end
    redirect_to users_url
  end

  def a_admin
    begin
      User.where(:id => params[:id]).update_all(:role => "admin")
      flash[:notice]="Admin Added"
    rescue
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

  def d_admin
    begin
      User.where(:id => params[:id]).update_all(:role => nil)
      flash[:notice]="Admin Removed"
    rescue
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

end
