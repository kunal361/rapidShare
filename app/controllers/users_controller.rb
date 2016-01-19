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
    if User.delete(params[:id]) != 0
      flash[:notice]="User Deleted"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

  def a_admin
    user = User.where({:id => params[:id]})
    if !user.empty?
      user.first.change_role(params[:id], "admin")
      flash[:notice]="Admin Added"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

  def d_admin
    user = User.where({:id => params[:id]})
    if !user.empty?
      user.first.change_role(params[:id], "nil")
      flash[:notice]="Admin removed"
    else
      flash[:notice]="No Such User"
    end
    redirect_to users_url
  end

end
