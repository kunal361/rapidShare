class DocumentsController < ApplicationController

  before_filter :require_user, :only => [:new, :index, :destroy, :show]

  def index
    @documents = Document.all
  end

  def new
  end

  def create
    description = params[:description]
    document = params[:doc]
    if !description || !document
      flash[:notice] = "Params Error"
      redirect_to add_url
    else
      user = session[:user_id]
      name = File.basename(document.original_filename)
      dir = "documents/"
      Dir.mkdir(dir) unless File.exists?(dir)
      path = File.join(dir, name)
      begin
        Document.new({:name => name, :description => description, :user_id => user}).save
        begin
          File.open(path, "wb") { |f| f.write(document.read) }
          flash[:notice]="File Uploaded Successfully!"
          redirect_to documents_url
        rescue
          flash[:notice]="Error uploading file"
          doc = Document.where({:name => name})[0]
          Document.delete(doc.id)
          redirect_to add_url
        end
      rescue Exception => e 
        puts e
        flash[:notice]="File with similar name already present"
        flash.alert
        redirect_to add_url
      end
    end
  end

  def show
    begin
      document = Document.find(params[:id])
      path = "documents/#{document.name}"
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
    begin
      @document = Document.find(params[:id])
      if @document.user_id == session[:user_id] || current_user.admin?
        begin
          File.delete("documents/"+@document.name)
          Document.delete(params[:id])
          flash[:notice]="File deleted"
        rescue
          flash[:notice]="You do not own this file"
        end
      end
    rescue
      flash[:notice]="No such file"
    end
    redirect_to root_url
  end

end