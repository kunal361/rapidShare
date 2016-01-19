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
    temp = current_user.documents.build(:document => document, :description => description)
    if temp.save
      flash[:notice]="File Uploaded Successfully!"
      redirect_to documents_url
    else
      flash[:notice]=""
      errors = temp.errors.full_messages
      errors.each do |error|
        flash[:notice] += "#{error}. "
      end
      redirect_to add_url
    end
  end

  def show
    if document = Document.find_by_id(params[:id])
      path = document.path
      File.open(path, "r") do |f|
        send_data f.read, :filename => document.name
      end
    else
      flash[:notice]="no such file"
      redirect_to root_url
    end
  end

  def destroy
    if document = Document.find_by_id(params[:id])
      if document.user_id == session[:user_id] || current_user.admin?
        Document.destroy(params[:id])
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