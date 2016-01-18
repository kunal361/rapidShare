class UsersController < ApplicationController

  before_filter :redirect_if_signed_in?, :only => [:new]
  before_filter :require_admin, :only => [:index, :destroy, :d_admin, :a_admin]

  def index
    @users = Users.all
  end

  def new
  end

  def create
    name = params[:user][:name]
    email = params[:user][:email]
    password = params[:user][:password]
    if !name || !email || !password || name== "" || email== "" || password== ""
      flash[:notice]="Params Error"
      redirect_to signup_url
    else
      begin
        user = Users.new({:name => name, :email => email, :password_digest => BCrypt::Password.create(password)})
        user.save
        flash[:notice]="Sucessfully signed up..."
        session[:user_id] = user.id
        redirect_to root_url
      rescue Exception => e
        puts e
        flash[:notice]="Email id already exists"
        redirect_to signup_url
      end
    end
  end

  def destroy
    begin
      if Users.delete(params[:id]) != 0
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
      user = Users.find(params[:id])
      user.role = "admin"
      user.save
      flash[:notice]="Admin Added"
    rescue
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

  def d_admin
    begin
      user = Users.find(params[:id])
      user.role = nil
      user.save
      flash[:notice]="Admin Removed"
    rescue
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

end
