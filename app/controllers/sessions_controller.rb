class SessionsController < ApplicationController

  before_filter :redirect_if_signed_in?, :only => [:new]

  def new
  end

  def create
    email = params[:session][:email]
    password = params[:session][:password]
    if !email || !password
      flash[:notice] = "Params Error"
      redirect_to login_url
    else
      user = Users.find_by_email(email)
      if user && BCrypt::Password.new(user.password_digest) == password
        session[:user_id] = user.id
        redirect_to root_url
      else
        flash[:notice] = "Incorrect Credentials"
        redirect_to login_url
      end
    end
  end

  def destroy
    session[:user_id]=nil
    redirect_to root_url
  end

end
