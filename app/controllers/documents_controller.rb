class DocumentsController < ApplicationController

  before_filter :require_user, :only => [:new, :index, :destroy, :show]

  def index
      @documents = current_user.admin? ? Document.all : current_user.documents
  end

  def new
    @document = Document.new
  end

  def create
    description = params[:document][:description]
    temp = params[:document][:doc]
    @document = current_user.documents.build(:path => temp, :description => description)
    if @document.save
      flash[:notice]="File Uploaded Successfully!"
      redirect_to documents_path
    else
      flash[:notice]="Error uploading files"
      render new_document_path
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