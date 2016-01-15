class DocumentsController < ApplicationController

  def index
    @documents = Documents.all
  end

  def new
  end

  def create
    name = File.basename(params[:doc].original_filename)
    dir = "public/documents/"
    Dir.mkdir(dir) unless File.exists?(dir)
    path = File.join(dir, name)
    begin
      Documents.new({:name => name, :description => params[:description]}).save
      begin
        File.open(path, "wb") { |f| f.write(params[:doc].read) }
        redirect_to "/documents"
      rescue
        flash[:notice]="Error uploading file"
        doc = Documents.where({:name => "temp.js"})[0]
        Documents.delete(doc.id)
        redirect_to "/add"
      end
    rescue
      flash[:notice]="File with similar name already present"
      flash.alert
      redirect_to "/add"
    end
  end

  def delete
    begin
      @document = Documents.find(params[:id])
      begin
        File.delete("public/documents/"+@document.name)
        Documents.delete(params[:id])
      rescue
        flash[:notice]="Error deleting file"
      end
    rescue
      flash[:notice]="no such file"
    end
    redirect_to "/documents"
  end

end