class UsersController < ApplicationController

  before_filter :require_admin, :only => [:index, :delete, :d_admin, :a_admin]

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
        user = Users.new({:name => name, :email => email, :password_digest => BCrypt::Password.create(password)}).save
        flash[:notice]="Sucessfully signed up...Please login"
        redirect_to login_url
      rescue Exception => e
        puts e
        flash[:notice]="Email id already exists"
        redirect_to signup_url
      end
    end
  end

  def delete
    flash[:notice]="User deleted"
    Users.delete(params[:id])
    redirect_to users_url
  end

  def a_admin
    user = Users.find(params[:id])
    user.role = "admin"
    user.save
    redirect_to users_url
  end

  def d_admin
    user = Users.find(params[:id])
    user.role = nil
    user.save
    redirect_to users_url
  end

end
