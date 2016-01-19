class DocumentsController < ApplicationController

  before_filter :require_user, :only => [:new, :index, :destroy, :show]

  def index
    @documents = Document.all
  end

  def new
  end

  def create
    description = params[:document][:description]
    document = params[:document][:doc]
    user = session[:user_id]
    temp = current_user.documents.build(:path => document, :description => description)
    if temp.save
      flash[:notice]="File Uploaded Successfully!"
      redirect_to documents_url
    else
      flash[:notice]=""
      errors = temp.errors.full_messages
      errors.each do |error|
        flash[:notice] += error
      end
      if flash[:notice].empty?
        flash[:notice] = "No Attachment"
      end
      redirect_to add_url
    end
  end

  def show
    begin
      document = Document.find(params[:id])
      path = document.path
      File.open(path, "r") do |f|
        send_data f.read, :filename => document.name
      end
    rescue Exception => e
      puts e
      flash[:notice]="no such file"
      redirect_to root_url
    end
  end

  def destroy
    if document = Document.find(params[:id])
      if document.user_id == session[:user_id] || current_user.admin?
          File.delete(document.path)
          Document.delete(params[:id])
          flash[:notice]="File deleted"
      else
        flash[:notice]="You do not own this file"
      end
    else
      flash[:notice]="No such file"
    end
    redirect_to root_url
  end

end